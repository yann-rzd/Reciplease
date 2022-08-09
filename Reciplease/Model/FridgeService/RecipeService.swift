//
//  RecipeService.swift
//  Reciplease
//
//  Created by Yann Rouzaud on 04/08/2022.
//

import Foundation
import CoreData


final class RecipeService {
    
    
    init(
        networkService: NetworkServiceProtocol = NetworkService.shared,
        recipeUrlProvider: RecipeUrlProviderProtocol = RecipeUrlProvider.shared,
        coreDataStack: CoreDataStack = CoreDataStack.shared
    ) {
        self.networkService = networkService
        self.recipeUrlProvider = recipeUrlProvider
        self.coreDataStack = coreDataStack
    }
    
    static let shared = RecipeService()
    
    var didProduceError: ((FridgeServiceError) -> Void)?
    var recipesDidChange: (() -> Void)?
    var favoriteRecipesDidChange: (() -> Void)?
    var isLoadingChanged: ((Bool) -> Void)?
    var isFetchingRecipesSuccess: ((Bool) -> Void)?
    
    var recipes: [RecipeElements] = [] {
        didSet {
            recipesDidChange?()
        }
    }
    
    var selectedRecipe: [RecipeElements] = []
    
    var favoriteRecipes: [RecipeEntity] = [] {
        didSet {
            favoriteRecipesDidChange?()
        }
    }
    
    var selectedFavoriteRecipe: [RecipeEntity] = []
    
    var isLoading = false {
        didSet {
            isLoadingChanged?(isLoading)
        }
    }

    
    // MARK: - INTERNAL: functions
    
    func removeRecipes() {
        recipes.removeAll()
    }
    
    func removeSelectedRecipe() {
        selectedRecipe.removeAll()
    }
    
    func fetchRecipes(
        ingredients: [String],
        completionHandler: @escaping (Result<RecipeElements, FridgeServiceError>) -> Void
    ) {
        
        guard let url = recipeUrlProvider.getRecipeUrl(ingredients: ingredients) else {
            self.didProduceError?(.failedToFetchRecipes)
            completionHandler(.failure(.failedToFetchRecipes))
            return
        }

        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "GET"
        
        isLoading = true
        
        networkService.fetch(urlRequest: urlRequest) { [weak self] (result: Result<RecipesResponse, NetworkServiceError>) in
            
            
            switch result {
            case .failure:
                completionHandler(.failure(.failedToFetchRecipes))
                self?.didProduceError?(.failedToFetchRecipes)
                self?.isFetchingRecipesSuccess?(false)
                return
            case .success(let recipeResponse):
                
                for hit in recipeResponse.hits {
                    let recipeLabel = hit.recipe.label
                    let recipeImage = hit.recipe.image
                    let recipeUrl = hit.recipe.url
                    let recipeYield = hit.recipe.yield
                    let recipeTotalTime = hit.recipe.totalTime
                    let recipeIngredients = hit.recipe.ingredientLines
                    var foodList: [String] = []
                    
                    for food in hit.recipe.ingredients {
                        let food = food.food
                        foodList.append(food)
                    }
                    
                    let recipe = RecipeElements(
                        label: recipeLabel,
                        image: recipeImage,
                        url: recipeUrl,
                        yield: recipeYield ,
                        ingredients: foodList.joined(separator: ", "),
                        ingredientsList: recipeIngredients,
                        time: recipeTotalTime
                    )
                    completionHandler(.success(recipe))
                    self?.recipes.append(recipe)
                }
                
                self?.isFetchingRecipesSuccess?(true)
                self?.isLoading = false
                return
            }
        }
    }
    
    func getRecipes(callback: @escaping ([RecipeEntity]) -> Void) {
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
        callback(recipes)
    }
    
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
    
    private let networkService: NetworkServiceProtocol
    private let recipeUrlProvider: RecipeUrlProviderProtocol
    private let coreDataStack: CoreDataStack
    
    
    
    // MARK: - PRIVATE: functions
    
    
    
}
