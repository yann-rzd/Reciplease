//
//  FridgeService.swift
//  Reciplease
//
//  Created by Yann Rouzaud on 01/08/2022.
//

import Foundation

final class FridgeService {
    
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
    
    func add(ingredient: String) {
        guard !addedIngredients.contains(ingredient) else {
            didProduceError?(.failedToAddNewIngredientAlreadyThere)
            return
        }
        
        addedIngredients.append(ingredient)
    }
}


