//
//  FridgeService.swift
//  Reciplease
//
//  Created by Yann Rouzaud on 01/08/2022.
//
import Foundation

final class FridgeService {
    
    init() {}
    
    // MARK: - INTERNAL: properties
    
    static let shared = FridgeService()
    
    var canAddIngredientDidChange: ((Bool) -> Void)?
    var canClearIngredientsDidChange: ((Bool) -> Void)?
    var didProduceError: ((RecipeServiceError) -> Void)?
    var ingredientsDidChange: (() -> Void)?
    var ingredientTextDidChange: ((String) -> Void)?
    var isSearchEnabled: ((Bool) -> Void)?
  
    
    var addedIngredients: [String] = [] {
        didSet {
            ingredientsDidChange?()
            canClearIngredientsDidChange?(addedIngredients.isEmpty)
            isSearchEnabled?(!addedIngredients.isEmpty)
        }
    }

    var ingredientText = "" {
        didSet {
            ingredientTextDidChange?(ingredientText)
            canAddIngredientDidChange?(ingredientText.isEmpty)
        }
    }
    
    // MARK: - INTERNAL: functions
    
    func add(ingredient: String) {
        let processedIngredient = ingredient.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        guard !addedIngredients.contains(processedIngredient) else {
            didProduceError?(.failedToAddNewIngredientAlreadyThere)
            return
        }
        addedIngredients.append(processedIngredient)
    }
    
    func clearIngredientsList() {
        addedIngredients.removeAll()
    }
    
    func emptyIngredientText() {
        ingredientText.removeAll()
    }
    
    func removeIngredient(ingredientIndex: Int) {
        let ingredientToRemove = addedIngredients[ingredientIndex]
        addedIngredients = addedIngredients.filter(){$0 != ingredientToRemove}
    }
}


