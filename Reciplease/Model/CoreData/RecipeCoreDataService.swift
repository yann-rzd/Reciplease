//
//  RecipeCoreDataService.swift
//  Reciplease
//
//  Created by Yann Rouzaud on 11/08/2022.
//

import Foundation
import CoreData

final class RecipeCoreDataService {
    
    // MARK: - INITIALIZER
    
    init(
        coreDataStack: CoreDataStack = CoreDataStack.shared
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
                    callback: @escaping () -> Void) {

        let recipe = RecipeEntity(context: coreDataStack.viewContext)
        
        recipe.title = title
        recipe.ingredients = ingredients
        recipe.ingredientsDetails = ingredientsDetails.description
        recipe.imageUrl = imageUrl
        recipe.url = url
        recipe.yield = yield
        recipe.recipeTime = recipeTime
        
        do {
            try coreDataStack.viewContext.save()
            callback()
        } catch {
            print("We were unable to save this recipe.")
        }
    }
    
    func getRecipes(callback: @escaping ([RecipeElements]) -> Void) {
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
        guard let recipes = try? coreDataStack.viewContext.fetch(request) else {
            callback([])
            return
        }
        
        
        
        var recipesElementsArray: [RecipeElements] = []
        
        for recipe in recipes {
            
            let ingredientsAsString = recipe.ingredientsDetails
            guard let ingredientsAsData = ingredientsAsString?.data(using: String.Encoding.utf16) else {
                return
            }
            
            let ingredientsDetails: [String]
            
            if let ingredientsArray: [String] = try? JSONDecoder().decode([String].self, from: ingredientsAsData) {
                ingredientsDetails = ingredientsArray
            } else {
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
                
        callback(recipesElementsArray)
    }
    
    func removeRecipe(recipe: RecipeEntity,
                    callback: @escaping () -> Void) {

        coreDataStack.viewContext.delete(recipe)
        
        do {
            try coreDataStack.viewContext.save()
            callback()
        } catch {
            print("We were unable to remove this recipe.")
        }
    }
    
    
    // MARK: - PRIVATE: properties
    
    private let coreDataStack: CoreDataStack
    private let recipeService = RecipeService.shared
}
