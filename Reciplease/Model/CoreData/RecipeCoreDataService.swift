//
//  RecipeCoreDataService.swift
//  Reciplease
//
//  Created by Yann Rouzaud on 11/08/2022.
//

import Foundation
import CoreData

final class RecipeCoreDataService: RecipeCoreDataServiceProtocol {
    
    // MARK: - INITIALIZER
    
    init(
        coreDataStack: CoreDataStack = CoreDataStack()
    ) {
        self.coreDataStack = coreDataStack
    }
    
    
    // MARK: - INTERNAL: properties
    
    static let shared = RecipeCoreDataService()
    
    
    // MARK: - INTERNAL: functions
    
    func saveRecipe(title: String,
                    ingredients: String,
                    ingredientsDetails: [String],
                    imageUrl: String,
                    url: String,
                    yield: Double,
                    recipeTime: Double,
                    callback: @escaping (Result<Void, RecipeCoreDataServiceError>) -> Void) {
        
        isRecipeAlreadySaved(recipeTitle: title) { [weak self] result in
            switch result {
            case .failure(let error):
                callback(.failure(error))
            case .success(let recipeIsAlreadyStored):
                guard !recipeIsAlreadyStored,
                      let self = self
                else {
                    callback(.failure(.failedToSaveRecipeBecauseAlreadyStored))
                    return
                }
                let recipe = RecipeEntity(context: self.coreDataStack.wrappedContext)
                
                recipe.title = title
                recipe.ingredients = ingredients
                recipe.ingredientsDetails = ingredientsDetails.description
                recipe.imageUrl = imageUrl
                recipe.url = url
                recipe.yield = yield
                recipe.recipeTime = recipeTime
                
                let context = self.coreDataStack.operationsContext
                
                do {
                    try context.save()
                    callback(.success(()))
                } catch {
                    print("We were unable to save this recipe.")
                    callback(.failure(.contextFailedToSaveRecipe))
                }
            }
        }
    }
    
    func isRecipeAlreadySaved(recipeTitle: String, callback: @escaping (Result<Bool, RecipeCoreDataServiceError>) -> Void) {
        getRecipes { result in
            switch result {
            case .failure(let error):
                callback(.failure(error))
            case .success(let recipes):
                let recipeIsAlreadyStored = recipes.contains { recipe in
                    recipe.label == recipeTitle
                }
                
                callback(.success(recipeIsAlreadyStored))
            }
        }
    }
    
    func getRecipes(callback: @escaping (Result<[RecipeElements], RecipeCoreDataServiceError>) -> Void) {
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "title", ascending: true),
            NSSortDescriptor(key: "ingredientsDetails", ascending: true),
            NSSortDescriptor(key: "ingredients", ascending: true),
            NSSortDescriptor(key: "imageUrl", ascending: true),
            NSSortDescriptor(key: "url", ascending: true),
            NSSortDescriptor(key: "yield", ascending: true),
            NSSortDescriptor(key: "recipeTime", ascending: true)
        ]
        
        guard let recipes = try? coreDataStack.operationsContext.fetch(request) else {
            callback(.failure(.failedToGetRecipesFromContext))
            return
        }

        var recipesElementsArray: [RecipeElements] = []
        
        for recipe in recipes {
            
            let ingredientsAsString = recipe.ingredientsDetails
            guard let ingredientsAsData = ingredientsAsString?.data(using: String.Encoding.utf16) else {
                callback(.failure(.failedToGetRecipesDueToDecodingFailure))
                return
            }
            
            let ingredientsDetails: [String]
            
            if let ingredientsArray: [String] = try? JSONDecoder().decode([String].self, from: ingredientsAsData) {
                ingredientsDetails = ingredientsArray
            } else {
                callback(.failure(.failedToGetRecipesDueToDecodingFailure))
                return
            }
            
            let recipesElements = RecipeElements(
                label: recipe.title,
                image: recipe.imageUrl,
                url: recipe.url,
                yield: recipe.yield,
                ingredients: recipe.ingredients,
                ingredientsList: ingredientsDetails,
                time: recipe.recipeTime
            )
            
            recipesElementsArray.append(recipesElements)
        }
                
        callback(.success(recipesElementsArray))
    }
    
    func removeRecipe(
        recipeTitle: String,
        callback: @escaping (Result<Void, RecipeCoreDataServiceError>) -> Void
    ) {
        let context: RecipleaseCoreDataContextProtocol = coreDataStack.operationsContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RecipeEntity")
        fetchRequest.predicate = NSPredicate(format: "title = %@", recipeTitle)
        
        if let results = try? context.fetch(fetchRequest) as? [NSManagedObject] {
            
            for object in results {
                context.delete(object)
            }
            
        } else {
            callback(.failure(.failedToRemoveRecipeBecauseInexisting))
            return
        }
        
        do {
            try context.save()
            callback(.success(()))
            return
        } catch {
            callback(.failure(.failedToRemoveRecipeFromContext))
            return
        }
    }
    
    
    // MARK: - PRIVATE: properties
    
    private let coreDataStack: CoreDataStack
}
