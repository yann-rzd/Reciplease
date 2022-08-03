//
//  RecipeResponse.swift
//  Reciplease
//
//  Created by Yann Rouzaud on 01/08/2022.
//

import Foundation

struct RecipesResponse: Codable {
    let hits: [Hit]
}

// MARK: - Hit
struct Hit: Codable {
    let recipe: Recipe
}

// MARK: - Recipe
struct Recipe: Codable {
    let label: String
    let image: String?
    let url: String
    let yield: Int
    let ingredientLines: [String]
    let ingredients: [RecipeDetails]
    let totalTime: Int
}

// MARK: - Recipe details
struct RecipeDetails: Codable {
    let food: String
}
