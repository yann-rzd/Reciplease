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
        urlComponents.path = "api/recipes/v2"
        urlComponents.queryItems = [
            .init(name: "type", value: "public"),
            .init(name: "app_id", value: "58aba0ee"),
            .init(name: "app_key", value: "fc4abb1b6c8a1687268a85e0bd262a2b"),
            .init(name: "imageSize", value: "REGULAR")
        ]
        
        for ingredient in ingredients {
            urlComponents.queryItems?.append(.init(name: "q", value: ingredient))
        }
        
        return urlComponents.url
    }
    

}
