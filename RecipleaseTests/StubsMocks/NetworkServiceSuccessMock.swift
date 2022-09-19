//
//  NetworkServiceSuccessMock.swift
//  RecipleaseTests
//
//  Created by Yann Rouzaud on 19/09/2022.
//

import Foundation
@testable import Reciplease

final class NetworkServiceSuccessMock: NetworkServiceProtocol {
    func fetch<T>(urlRequest: URLRequest, completionHandler: @escaping (Result<T, NetworkServiceError>) -> Void) where T : Decodable, T : Encodable {
        let response = RecipesResponse(hits: [
            Hit(
                recipe: Recipe(
                    label: "Pizza",
                    image: nil,
                    url: "www.google.com",
                    yield: 10,
                    ingredientLines: [],
                    ingredients: [
                        RecipeDetails(food: "Salad")
                    ],
                    totalTime: 10
                )
            )
        ])
        let result: Result<RecipesResponse, NetworkServiceError> = .success(response)
        completionHandler(result as! Result<T, NetworkServiceError>)
    }
    
    func fetch<T>(url: URL, completionHandler: @escaping (Result<T, NetworkServiceError>) -> Void) where T : Decodable, T : Encodable {
        let response = RecipesResponse(hits: [
            Hit(
                recipe: Recipe(
                    label: "Pizza",
                    image: nil,
                    url: "www.google.com",
                    yield: 10,
                    ingredientLines: [],
                    ingredients: [],
                    totalTime: 10
                )
            )
        ])
        let result: Result<RecipesResponse, NetworkServiceError> = .success(response)
        completionHandler(result as! Result<T, NetworkServiceError>)
    }
    
    
}
