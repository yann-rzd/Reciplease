//
//  RecipeUrlProvider.swift
//  Reciplease
//
//  Created by Yann Rouzaud on 01/08/2022.
//

import Foundation


protocol RecipeUrlProviderProtocol {
    func getRecipeUrl(ingredients: [String]) -> URL?
}

final class RecipeUrlProvider: RecipeUrlProviderProtocol {
    
    static let shared = RecipeUrlProvider()

    func getRecipeUrl(ingredients: [String]) -> URL? {

        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.edamam.com"
        urlComponents.path = "/api/recipes/v2"
        urlComponents.queryItems = [
            .init(name: "type", value: "public"),
            .init(name: "app_id", value: "58aba0ee"),
            .init(name: "app_key", value: APIKeys.recipeKey),
            .init(name: "imageSize", value: "LARGE"),
            .init(name: "q", value: ingredients.joined(separator: " "))
        ]

        return urlComponents.url
    }
}
