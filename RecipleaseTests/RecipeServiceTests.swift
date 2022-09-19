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
        XCTAssertEqual(recipeService.favoriteRecipes.count, 0)
        
        let selectedRecipe =
            RecipeElements(
                label: Optional("Frothy Iced Matcha Green Tea Recipe"),
                image: Optional("https://fakeUrl.com"),
                url: Optional("http://www.seriouseats.com/recipes/2016/08/iced-matcha-green-tea-recipe.html"),
                yield: 2.0,
                ingredients: Optional("green tea, water"),
                ingredientsList: Optional(["2 teaspoons (6g) Japanese matcha green tea (see note above)", "8 ounces (235ml) cold water"]),
                time: 2.0
            )
       
        
        recipeService.toggleSelectedFavoriteRecipe(selectedRecipe: selectedRecipe)
        
        
        recipeService.removeFavoriteRecipe(recipeTitle: "Frothy Iced Matcha Green Tea Recipe")
        
        let expectation = XCTestExpectation(description: "Wait for callback")
        
        
        recipeService.isRecipeAddedToFavorite = { isFavorited in
            XCTAssertFalse(isFavorited)
            
            expectation.fulfill()

        }
        
        recipeService.updateAndNotifyFavoritedStateWithSelectedRecipe(selectedRecipe: selectedRecipe)
        
        wait(for: [expectation], timeout: 0.1)

    }
    
    
    
    func test_givenNoRecipe_whenToggleRecipeToFavorite_thenDoesProduceFailedToToggleError() {
        let expectation = XCTestExpectation(description: "Wait for callback")
        
        recipeService.didProduceError = { error in
            XCTAssertEqual(error, .failedToToggleRecipeFavoriteState)
            
            expectation.fulfill()
        }
        
        recipeService.toggleSelectedFavoriteRecipe(selectedRecipe: nil)
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    
    func test_givenNonfonctionalCoreDataService_whenToggleRecipeToFavorite_thenFailedToToggleError() {

        let recipeService = RecipeService(recipeCoreDataService: RecipeCoreDataServiceMock())
        
        let selectedRecipe =
            RecipeElements(
                label: Optional("Frothy Iced Matcha Green Tea Recipe"),
                image: Optional("https://fakeUrl.com"),
                url: Optional("http://www.seriouseats.com/recipes/2016/08/iced-matcha-green-tea-recipe.html"),
                yield: 2.0,
                ingredients: Optional("green tea, water"),
                ingredientsList: Optional(["2 teaspoons (6g) Japanese matcha green tea (see note above)", "8 ounces (235ml) cold water"]),
                time: 2.0
            )
        
        
        let expectation = XCTestExpectation(description: "Wait for callback")
        
        recipeService.didProduceError = { error in
            XCTAssertEqual(error, .failedToToggleRecipeFavoriteState)
            
            expectation.fulfill()
        }
        
        recipeService.toggleSelectedFavoriteRecipe(selectedRecipe: selectedRecipe)
        
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    
    func test_givenAlreadySavecRecipe_whenToggleRecipeToFavorite_thenFavoritedStateChangedToFalse() {

        
        // given
        
        let selectedRecipe =
            RecipeElements(
                label: Optional("Frothy Iced Matcha Green Tea Recipe"),
                image: Optional("https://fakeUrl.com"),
                url: Optional("http://www.seriouseats.com/recipes/2016/08/iced-matcha-green-tea-recipe.html"),
                yield: 2.0,
                ingredients: Optional("green tea, water"),
                ingredientsList: Optional(["2 teaspoons (6g) Japanese matcha green tea (see note above)", "8 ounces (235ml) cold water"]),
                time: 2.0
            )
        
        recipeService.toggleSelectedFavoriteRecipe(selectedRecipe: selectedRecipe)
        
        
        
        
        // when
        
        let expectation = XCTestExpectation(description: "Wait for callback")
        
        recipeService.isRecipeAddedToFavorite = { isFavorited in
            XCTAssertFalse(isFavorited)
            
            expectation.fulfill()
        }
        
        recipeService.toggleSelectedFavoriteRecipe(selectedRecipe: selectedRecipe)
        
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    
    func test_givenRecipeCoreDataServiceAlreadySavedRemoveFail_whenToggleRecipeToFavorite_thenFailedToToggleError() {

        let recipeService = RecipeService(recipeCoreDataService: RecipeCoreDataServiceAlreadySavedRemoveFailMock())
        
        let selectedRecipe =
            RecipeElements(
                label: Optional("Frothy Iced Matcha Green Tea Recipe"),
                image: Optional("https://fakeUrl.com"),
                url: Optional("http://www.seriouseats.com/recipes/2016/08/iced-matcha-green-tea-recipe.html"),
                yield: 2.0,
                ingredients: Optional("green tea, water"),
                ingredientsList: Optional(["2 teaspoons (6g) Japanese matcha green tea (see note above)", "8 ounces (235ml) cold water"]),
                time: 2.0
            )
        
        
        let expectation = XCTestExpectation(description: "Wait for callback")
        
        recipeService.didProduceError = { error in
            XCTAssertEqual(error, .failedToToggleRecipeFavoriteState)
            
            expectation.fulfill()
        }
        
        recipeService.toggleSelectedFavoriteRecipe(selectedRecipe: selectedRecipe)
        
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    
    func test_givenRecipeCoreDataServiceIsNotAlreadySavedSaveFail_whenToggleRecipeToFavorite_thenFailedToToggleError() {

        let recipeService = RecipeService(recipeCoreDataService: RecipeCoreDataServiceIsNotAlreadySavedSaveFailMock())
        
        let selectedRecipe =
            RecipeElements(
                label: Optional("Frothy Iced Matcha Green Tea Recipe"),
                image: Optional("https://fakeUrl.com"),
                url: Optional("http://www.seriouseats.com/recipes/2016/08/iced-matcha-green-tea-recipe.html"),
                yield: 2.0,
                ingredients: Optional("green tea, water"),
                ingredientsList: Optional(["2 teaspoons (6g) Japanese matcha green tea (see note above)", "8 ounces (235ml) cold water"]),
                time: 2.0
            )
        
        
        let expectation = XCTestExpectation(description: "Wait for callback")
        
        recipeService.didProduceError = { error in
            XCTAssertEqual(error, .failedToSaveRecipe)
            
            expectation.fulfill()
        }
        
        recipeService.toggleSelectedFavoriteRecipe(selectedRecipe: selectedRecipe)
        
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    
    
    
    func test_givenNoRecipe_whenUpdateAndNotifyFavoritedStateWithSelectedRecipe_thenFailedToUpdateIsFavoritedState() {
        
        let expectation = XCTestExpectation(description: "Wait for callback")
        
        recipeService.didProduceError = { error in
            XCTAssertEqual(error, .failedToUpdateIsFavoritedState)
            
            expectation.fulfill()
        }
        
        recipeService.updateAndNotifyFavoritedStateWithSelectedRecipe(selectedRecipe: nil)
        
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_givenRecipeAndFailingCoreDataServiceToRemove_whenUpdateAndNotifyFavoritedStateWithSelectedRecipe_thenFailedToUpdateIsFavoritedState() {
        
        
        let recipeService = RecipeService(recipeCoreDataService: RecipeCoreDataServiceMock())
        
        let selectedRecipe =
            RecipeElements(
                label: Optional("Frothy Iced Matcha Green Tea Recipe"),
                image: Optional("https://fakeUrl.com"),
                url: Optional("http://www.seriouseats.com/recipes/2016/08/iced-matcha-green-tea-recipe.html"),
                yield: 2.0,
                ingredients: Optional("green tea, water"),
                ingredientsList: Optional(["2 teaspoons (6g) Japanese matcha green tea (see note above)", "8 ounces (235ml) cold water"]),
                time: 2.0
            )
        
        let expectation = XCTestExpectation(description: "Wait for callback")
        
        recipeService.didProduceError = { error in
            XCTAssertEqual(error, .failedToUpdateIsFavoritedState)
            
            expectation.fulfill()
        }
        
        recipeService.updateAndNotifyFavoritedStateWithSelectedRecipe(selectedRecipe: selectedRecipe)
        
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    
    
    
    
    func test_givenFailingCoreDataGetRecipes_whenGetRecipes_thenFailedToGetRecipe()
    {
        let recipeService = RecipeService(recipeCoreDataService: RecipeCoreDataServiceMock())
        
        let expectation = XCTestExpectation(description: "Wait for callback")
        
        recipeService.didProduceError = { error in
            XCTAssertEqual(error, .failedToGetRecipe)
            
            expectation.fulfill()
        }
        
        recipeService.getRecipes()
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    
    func test_givenNotStoreRecipeTitle_whenRemvoeFavoriteRecipe_thenFailedToRemoveRecipe()
    {
        
        let expectation = XCTestExpectation(description: "Wait for callback")
        
        recipeService.didProduceError = { error in
            XCTAssertEqual(error, .failedToRemoveRecipe)
            
            expectation.fulfill()
        }
        
        recipeService.removeFavoriteRecipe(recipeTitle: "asdasd")
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    
    
    
    func test_givenNetworkFailure_whenFetchRecipes_thenFailedToFetchRecipes()
    {
        
        let recipeService = RecipeService(networkService: NetworkServiceFailureMock())
        
        let expectation = XCTestExpectation(description: "Wait for callback")
        
        
        recipeService.didProduceError = { error in
            XCTAssertEqual(error, .failedToFetchRecipes)
            expectation.fulfill()
        }
        
        recipeService.fetchRecipes(ingredients: [])
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    
    
    func test_givenUrlProviderFailure_whenFetchRecipes_thenFailedToFetchRecipes()
    {
        
        let recipeService = RecipeService(recipeUrlProvider: RecipeUrlProviderFailureMock())
        
        let expectation = XCTestExpectation(description: "Wait for callback")
        
        recipeService.didProduceError = { error in
            XCTAssertEqual(error, .failedToFetchRecipes)
            expectation.fulfill()
        }
        
        recipeService.fetchRecipes(ingredients: [])
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    
    func test_givenNetworkServiceProvidingHits_whenFetchRecipes_thenGetRecipes()
    {
        
        let recipeService = RecipeService(networkService: NetworkServiceSuccessMock())
        
        let expectation = XCTestExpectation(description: "Wait for callback")
        
        recipeService.recipesDidChange = {
            XCTAssertFalse(recipeService.recipes.isEmpty)
            expectation.fulfill()
        }
        
        recipeService.fetchRecipes(ingredients: [])
        
        wait(for: [expectation], timeout: 0.1)
    }
}










