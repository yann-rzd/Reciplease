//
//  RecipeService.swift
//  Reciplease
//
//  Created by Yann Rouzaud on 04/08/2022.
//

import Foundation


final class RecipeService {
    static let shared = RecipeService()
    
    init(
        networkService: NetworkServiceProtocol = NetworkService.shared,
        recipeUrlProvider: RecipeUrlProviderProtocol = RecipeUrlProvider.shared
    ) {
        self.networkService = networkService
        self.recipeUrlProvider = recipeUrlProvider
    }
    
    var didProduceError: ((FridgeServiceError) -> Void)?
    var recipesDidChange: (() -> Void)?
    var isLoadingChanged: ((Bool) -> Void)?
    
    var recipes: [RecipeElements] = [] {
        didSet {
            recipesDidChange?()
        }
    }
    
    var isLoading = false {
        didSet {
            isLoadingChanged?(isLoading)
        }
    }
    
    func fetchRecipes(ingredients: [String]) {
        currentDownloadCount += 1
        fetchRecipes(ingredients: ingredients) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.didProduceError?(error)
            case .success(let recipes):
                self?.recipes.append(recipes)
            }
            self?.currentDownloadCount -= 1
        }
    }
    
    // MARK: - PRIVATE: properties
    
    private let networkService: NetworkServiceProtocol
    private let recipeUrlProvider: RecipeUrlProviderProtocol
    
    private var currentDownloadCount = 0 {
        didSet {
            isLoadingChanged?(isLoading)
        }
    }
    
    
    // MARK: - PRIVATE: functions
    
    private func fetchRecipes(
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
            self?.isLoading = false
            
            switch result {
            case .failure:
                completionHandler(.failure(.failedToFetchRecipes))
                self?.didProduceError?(.failedToFetchRecipes)
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
                }
                
                return
            }
            
        }
    }
    
}
