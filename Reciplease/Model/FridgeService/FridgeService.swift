//
//  FridgeService.swift
//  Reciplease
//
//  Created by Yann Rouzaud on 01/08/2022.
//

import Foundation

final class FridgeService {
    
    init(
        networkService: NetworkServiceProtocol = NetworkService.shared,
        recipeUrlProvider: RecipeUrlProviderProtocol = RecipeUrlProvider.shared
    ) {
        self.networkService = networkService
        self.recipeUrlProvider = recipeUrlProvider
    }
    
    
    // MARK: - INTERNAL: properties
    
    static let shared = FridgeService()
    
    var didProduceError: ((FridgeServiceError) -> Void)?
    var ingredientsDidChange: (() -> Void)?
    var ingredientTextDidChange: ((String) -> Void)?
    var recipesDidChange: (() -> Void)?
    
    var addedIngredients: [String] = [] {
        didSet {
            ingredientsDidChange?()
        }
    }

    var ingredientText = "" {
        didSet {
            ingredientTextDidChange?(ingredientText)
        }
    }
    
    var recipes: [RecipeElements] = [] {
        didSet {
            recipesDidChange?()
        }
    }
    
    
    
    
    // MARK: - INTERNAL: functions
    
    func add(ingredient: String) {
        guard !addedIngredients.contains(ingredient) else {
            didProduceError?(.failedToAddNewIngredientAlreadyThere)
            return
        }
        addedIngredients.append(ingredient)
    }
    
    func clearIngredientsList() {
        addedIngredients.removeAll()
    }
    
    func emptyIngredientText() {
        ingredientText.removeAll()
    }
    
    func fetchRecipes() {
        fetch() { [weak self] result in
            switch result {
            case .failure(let error):
                self?.didProduceError?(error)
            case .success(let recipes):
                self?.recipes.append(recipes)
            }
        }
    }

    
    // MARK: - PRIVATE: properties
    
    private let networkService: NetworkServiceProtocol
    private let recipeUrlProvider: RecipeUrlProviderProtocol
    
    
    // MARK: - PRIVATE: functions
    
    private func fetch(completionHandler: @escaping (Result<RecipeElements, FridgeServiceError>) -> Void) {
        
        guard let url = recipeUrlProvider.getRecipeUrl(ingredients: addedIngredients) else {
            self.didProduceError?(.failedToFetchRecipes)
            completionHandler(.failure(.failedToFetchRecipes))
            return
        }

        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "GET"
        
        networkService.fetch(urlRequest: urlRequest) { [weak self] (result: Result<RecipesResponse, NetworkServiceError>) in
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


