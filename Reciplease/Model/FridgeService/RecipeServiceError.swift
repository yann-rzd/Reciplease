//
//  FridgeServiceError.swift
//  Reciplease
//
//  Created by Yann Rouzaud on 01/08/2022.
//

import Foundation

enum RecipeServiceError: LocalizedError {
    case failedToFetchRecipes
    case failedToAddNewIngredientAlreadyThere
    case noRecipeFound
    case failedToGetRecipe
    case failedToSaveRecipe
    case failedToToggleRecipeFavoriteState
    case failedToRemoveRecipe
    case failedToUpdateIsFavoritedState
    
    var errorDescription: String? {
        switch self {
        case .failedToFetchRecipes:
            return  "Failed to fetch recipes."
        case .failedToAddNewIngredientAlreadyThere:
            return "Failed to add ingredient to selection as it is already present."
        case .noRecipeFound:
            return "No recipes have been found."
        case .failedToSaveRecipe:
            return "Failed to save recipe."
        case .failedToGetRecipe:
            return "Failed to get recipes from stoage."
        case .failedToToggleRecipeFavoriteState:
            return "Failed to toggle recipe favorite state."
        case .failedToRemoveRecipe:
            return "Failed to remove recipe."
        case .failedToUpdateIsFavoritedState:
            return "Failed to update favorited state."
        }
    }
    
}
