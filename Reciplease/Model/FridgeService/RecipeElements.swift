//
//  Recipe.swift
//  Reciplease
//
//  Created by Yann Rouzaud on 03/08/2022.
//

import Foundation

struct RecipeElements: Equatable {
    let label: String?
    let image: String?
    let url: String?
    let yield: Double
    let ingredients: String?
    let ingredientsList: [String]?
    let time: Double
}
