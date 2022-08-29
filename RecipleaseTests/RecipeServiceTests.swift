//
//  RecipleaseTests.swift
//  RecipleaseTests
//
//  Created by Yann Rouzaud on 28/07/2022.
//

import XCTest
@testable import Reciplease

final class RecipeServiceTests: XCTestCase {

    var recipeService: RecipeService!
    
    override func setUp() {
        super.setUp()
        recipeService = RecipeService()
    }
    
    func testGivenRecipesSearched_WhenRemoveRecipes_ThenRecipesEmpty() {
        recipeService.recipes = [
            Reciplease.RecipeElements(
                label: Optional("Frothy Iced Matcha Green Tea Recipe"),
                image: Optional("https://fakeUrl.com"),
                url: Optional("http://www.seriouseats.com/recipes/2016/08/iced-matcha-green-tea-recipe.html"),
                yield: 2.0,
                ingredients: Optional("green tea, water"),
                ingredientsList: Optional(["2 teaspoons (6g) Japanese matcha green tea (see note above)", "8 ounces (235ml) cold water"]),
                time: 2.0
            )
        ]
        recipeService.removeRecipes()
        
        XCTAssertTrue(recipeService.recipes.isEmpty)
    }
    
    func testGivenRecipeSelected_WhenRemoveRecipeSelected_ThenRecipeSelectedEmpty() {
        recipeService.selectedRecipe =
            Reciplease.RecipeElements(
                label: Optional("Frothy Iced Matcha Green Tea Recipe"),
                image: Optional("https://fakeUrl.com"),
                url: Optional("http://www.seriouseats.com/recipes/2016/08/iced-matcha-green-tea-recipe.html"),
                yield: 2.0,
                ingredients: Optional("green tea, water"),
                ingredientsList: Optional(["2 teaspoons (6g) Japanese matcha green tea (see note above)", "8 ounces (235ml) cold water"]),
                time: 2.0
            )
        
        recipeService.removeSelectedRecipe()
        
        XCTAssertEqual(recipeService.selectedRecipe, nil)
    }
}
