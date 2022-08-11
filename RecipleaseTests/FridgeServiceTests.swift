//
//  FridgeServiceTests.swift
//  RecipleaseTests
//
//  Created by Yann Rouzaud on 11/08/2022.
//

import XCTest
@testable import Reciplease

class FridgeServiceTests: XCTestCase {
    var fridgeService: FridgeService!
    
    override func setUp() {
        super.setUp()
        fridgeService = FridgeService()
    }
    
    func testGivenNoIngredientsAdded_WhenAddIngredient_ThenIngredientAdded() {
        fridgeService.addedIngredients = []
        fridgeService.add(ingredient: "Apple")
        
        XCTAssertEqual(fridgeService.addedIngredients, ["apple"])
    }
    
    func testGivenIngredientAdded_WhenAddSameIngredient_ThenIngredientNotAdded() {
        fridgeService.addedIngredients = ["apple"]
        fridgeService.add(ingredient: "Apple")
        
        XCTAssertEqual(fridgeService.addedIngredients, ["apple"])
        
    }
    
    func testGivenIngredientsInList_WhenClearIngredientsList_ThenListIngredientsIsEmpty() {
        fridgeService.addedIngredients = ["apple", "lemon", "cherry"]
        fridgeService.clearIngredientsList()
        
        XCTAssertEqual(fridgeService.addedIngredients, [])
    }
    
    func testGivenIngredientWriteInTextField_WhenEmptyIngretientText_ThenIngredientTextEmpty() {
        fridgeService.ingredientText = "apple"
        fridgeService.emptyIngredientText()
        
        XCTAssertEqual(fridgeService.ingredientText, "")
    }
    
    func testGivenIngredientsAdded_WhenRemoveIngredient_ThenIngredientRemoved() {
        fridgeService.addedIngredients = ["apple", "lemon", "cherry"]
        fridgeService.removeIngredient(ingredientIndex: 1)
        
        XCTAssertEqual(fridgeService.addedIngredients, ["apple", "cherry"])
    }
    
}
