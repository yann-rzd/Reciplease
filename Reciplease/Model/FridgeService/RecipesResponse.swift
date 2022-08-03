//
//  RecipeResponse.swift
//  Reciplease
//
//  Created by Yann Rouzaud on 01/08/2022.
//

import Foundation

struct RecipesResponse: Decodable {
    let hits: [Hit]
}

// MARK: - Hit
struct Hit: Decodable {
    let recipe: Recipe
}

// MARK: - Recipe
struct Recipe: Decodable {
    let label: String
    let image: String?
    let url: String
    let yield: Double
    let ingredientLines: [String]
    let ingredients: [RecipeDetails]
    let totalTime: Double?
}

// MARK: - Recipe details
struct RecipeDetails: Decodable {
    let text: String
    let quantity: Double
    let measure: String
    let food: String
    let weight: Double
    let foodCategory: String
    let image: String?
}
