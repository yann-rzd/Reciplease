//
//  RecipeCoreDataServiceProtocol.swift
//  Reciplease
//
//  Created by Yann Rouzaud on 19/09/2022.
//

import Foundation

protocol RecipeCoreDataServiceProtocol {
    func saveRecipe(title: String,
                    ingredients: String,
                    ingredientsDetails: [String],
                    imageUrl: String,
                    url: String,
                    yield: Double,
                    recipeTime: Double,
                    callback: @escaping (Result<Void, RecipeCoreDataServiceError>) -> Void)
    
    func isRecipeAlreadySaved(recipeTitle: String, callback: @escaping (Result<Bool, RecipeCoreDataServiceError>) -> Void)
    
    func getRecipes(callback: @escaping (Result<[RecipeElements], RecipeCoreDataServiceError>) -> Void)
    
    func removeRecipe(recipeTitle: String,
                    callback: @escaping (Result<Void, RecipeCoreDataServiceError>) -> Void)
}
