//
//  RecipeCoreDataServiceError.swift
//  Reciplease
//
//  Created by Yann Rouzaud on 19/09/2022.
//

import Foundation

enum RecipeCoreDataServiceError: Error {
    case failedToSaveRecipeBecauseAlreadyStored
    case contextFailedToSaveRecipe
    case failedToGetRecipesFromContext
    case failedToGetRecipesDueToDecodingFailure
    case failedToRemoveRecipeFromContext
    case failedToRemoveRecipeBecauseInexisting
}
