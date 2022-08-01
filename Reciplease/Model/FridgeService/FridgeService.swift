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
    
    var ingredientsDidChange: (() -> Void)?

    var addedIngredients : [String] = [] {
        didSet {
            ingredientsDidChange?()
        }
    }

    var ingredientTextDidChange: ((String) -> Void)?

    var ingredientText = "" {
        didSet {
            ingredientTextDidChange?(ingredientText)
        }
    }
    
    var didProduceError: ((FridgeServiceError) -> Void)?
    
    
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
    
    // MARK: - PRIVATE: properties
    
    private let networkService: NetworkServiceProtocol
    private let recipeUrlProvider: RecipeUrlProviderProtocol
    
    
    // MARK: - PRIVATE: functions
}


