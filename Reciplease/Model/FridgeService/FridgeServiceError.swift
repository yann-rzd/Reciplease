//
//  FridgeServiceError.swift
//  Reciplease
//
//  Created by Yann Rouzaud on 01/08/2022.
//

import Foundation

enum FridgeServiceError: LocalizedError {
    case failedToFetchRecipes
    case failedToAddNewIngredientAlreadyThere
    
    var errorDescription: String {
        switch self {
        case .failedToFetchRecipes:
            return  "Failed to fetch recipes."
        case .failedToAddNewIngredientAlreadyThere:
            return "Failed to add ingredient to selection as it is already present."
        }
    }
    
}
