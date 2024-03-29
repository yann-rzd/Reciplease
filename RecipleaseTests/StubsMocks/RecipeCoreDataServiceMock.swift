//
//  RecipeCoreDataServiceMock.swift
//  RecipleaseTests
//
//  Created by Yann Rouzaud on 15/09/2022.
//

import Foundation
@testable import Reciplease

final class RecipeCoreDataServiceMock: RecipeCoreDataServiceProtocol {
    
    
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
        callback(.failure(.failedToGetRecipesFromContext))
    }
    
    func getRecipes(callback: @escaping (Result<[RecipeElements], RecipeCoreDataServiceError>) -> Void) {
        callback(.failure(.failedToGetRecipesFromContext))
    }
    
    func removeRecipe(recipeTitle: String, callback: @escaping (Result<Void, RecipeCoreDataServiceError>) -> Void) {
        
    }
    
}
