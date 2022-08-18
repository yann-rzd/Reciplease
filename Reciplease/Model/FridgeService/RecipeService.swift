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
        recipeCoreDataService: RecipeCoreDataService = RecipeCoreDataService.shared
    ) {
        self.networkService = networkService
        self.recipeUrlProvider = recipeUrlProvider
        self.recipeCoreDataService = recipeCoreDataService
    }
    
    static let shared = RecipeService()
    
    var didProduceError: ((FridgeServiceError) -> Void)?
    var recipesDidChange: (() -> Void)?
    var favoriteRecipesDidChange: (() -> Void)?
    var isLoadingChanged: ((Bool) -> Void)?
    var isFetchingRecipesSuccess: ((Bool) -> Void)?
    var isRecipeAddedToFavorite: (() -> Void)?
    
    var recipes: [RecipeElements] = [] {
        didSet {
            recipesDidChange?()
        }
    }
    
    var selectedRecipe: RecipeElements?
    
    var favoriteRecipes: [RecipeElements] = [] {
        didSet {
            favoriteRecipesDidChange?()
        }
    }
    
    var isLoading = false {
        didSet {
            isLoadingChanged?(isLoading)
        }
    }

    
    // MARK: - INTERNAL: functions
    
    func toggleSelectedFavoriteRecipe() {
        guard
            let selectedRecipe = selectedRecipe,
            let title = selectedRecipe.label,
            let ingredients = selectedRecipe.ingredients,
            let ingredientsDetails = selectedRecipe.ingredientsList,
            let imageUrl = selectedRecipe.image,
            let url = selectedRecipe.url
        else {
            return
        }
        
        let yield = selectedRecipe.yield
        let recipeTime = selectedRecipe.time
        
        recipeCoreDataService.saveRecipe(
            title: title,
            ingredients: ingredients,
            ingredientsDetails: ingredientsDetails,
            imageUrl: imageUrl,
            url: url,
            yield: yield,
            recipeTime: recipeTime,
            callback: { [weak self] in
                self?.isRecipeAddedToFavorite?()
            }
        )
    }
    
    func getRecipes() {
        recipeCoreDataService.getRecipes(callback: { [weak self] recipes in
//            favoriteRecipes = []
            self?.favoriteRecipes = recipes
        })
    }
    
    func removeFavoriteRecipe(recipeTitle: String) {
        recipeCoreDataService.removeRecipe(recipeTitle: recipeTitle, callback: { [weak self] in
            self?.getRecipes()
        })
    }
    
    func removeRecipes() {
        recipes.removeAll()
    }
    
    func removeSelectedRecipe() {
        selectedRecipe = nil
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
    
    // MARK: - PRIVATE: properties
    
    
    
    private let networkService: NetworkServiceProtocol
    private let recipeUrlProvider: RecipeUrlProviderProtocol
    private let recipeCoreDataService: RecipeCoreDataService
    
    
}
