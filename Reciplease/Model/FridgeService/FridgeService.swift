//
//  FridgeService.swift
//  Reciplease
//
//  Created by Yann Rouzaud on 01/08/2022.
//

import Foundation

final class FridgeService {
    
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
    
    func emptyIngredientText() {
        ingredientText = ""
    }
    
    // MARK: - PRIVATE: properties
    
    // MARK: - PRIVATE: functions
}


