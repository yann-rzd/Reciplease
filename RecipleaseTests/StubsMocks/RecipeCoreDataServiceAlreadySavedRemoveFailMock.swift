//
//  RecipeCoreDataServiceAlreadySavedRemoveFailMock.swift
//  RecipleaseTests
//
//  Created by Yann Rouzaud on 03/10/2022.
//

import Foundation
@testable import Reciplease

final class RecipeCoreDataServiceAlreadySavedRemoveFailMock: RecipeCoreDataServiceProtocol {


    func saveRecipe(
        title: String,
        ingredients: String,
        ingredientsDetails: [String],
        imageUrl: String,
        url: String,
        yield: Double,
        recipeTime: Double,
        callback: @escaping (Result<Void, RecipeCoreDataServiceError>) -> Void
    ) {


    }

    func isRecipeAlreadySaved(recipeTitle: String, callback: @escaping (Result<Bool, RecipeCoreDataServiceError>) -> Void) {
        callback(.success(true))
    }

    func getRecipes(callback: @escaping (Result<[RecipeElements], RecipeCoreDataServiceError>) -> Void) {

    }

    func removeRecipe(recipeTitle: String, callback: @escaping (Result<Void, RecipeCoreDataServiceError>) -> Void) {
        callback(.failure(.failedToRemoveRecipeFromContext))
    }

}
