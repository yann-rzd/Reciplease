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
            .init(name: "app_key", value: "fc4abb1b6c8a1687268a85e0bd262a2b"),
            .init(name: "imageSize", value: "LARGE"),
            .init(name: "q", value: ingredients.joined(separator: " "))
        ]

        return urlComponents.url
    }
}

//
//
//protocol EdamamUrlProviderProtocol {
//    func getRecipesRequest(ingredients: [String]) throws -> URLRequest
//}
//
//final class EdamamUrlProvider: EdamamUrlProviderProtocol {
//    static let shared = EdamamUrlProvider()
//    private init() { }
//
//    func getRecipesRequest(ingredients: [String]) throws -> URLRequest {
//        var urlComponents = URLComponents()
//        urlComponents.scheme = "https"
//        urlComponents.host = "api.edamam.com"
//        urlComponents.path = "/api/recipes/v2"
//
//        //let url = urlComponents(string: "https://api.edamam.com/api/recipes/v2")!
//
//        guard let url = urlComponents.url else {
//            throw NetworkServiceError.badUrlRequest // TODO: SHould change error type
//        }
//
//        let urlRequest = URLRequest(url: url)
//
//        let parameters: [String: String] = [
//            "type": "public",
//            "app_id": "58aba0ee",
//            "app_key": "fc4abb1b6c8a1687268a85e0bd262a2b",
//            "imageSize": "LARGE",
//            "q": ingredients.joined(separator: " ")
//        ]
//
//        do {
//            let encodedURLRequest = try URLEncodedFormParameterEncoder.default.encode(parameters, into: urlRequest)
//            return encodedURLRequest
//        } catch {
//            throw NetworkServiceError.badUrlRequest
//        }
//    }
//}
