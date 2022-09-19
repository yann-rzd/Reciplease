//
//  RecipeCoreDataServiceTests.swift
//  RecipleaseTests
//
//  Created by Yann Rouzaud on 11/08/2022.
//

import XCTest
@testable import Reciplease

class RecipeCoreDataServiceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func testGivenFailingContextFetch_whenRemoveRecipe_thenError() {

        let mockCoreDataContext = CoreDataContextFailureMock(
            isSaveFailing: false,
            isFetchFailing: true
        )

        let coreDataStack = CoreDataStack(inMemory: true, operationsContext: mockCoreDataContext)
        
        mockCoreDataContext.coreDataStack = coreDataStack
        
        let recipeCoreDataService = RecipeCoreDataService(coreDataStack: coreDataStack)


        recipeCoreDataService.removeRecipe(recipeTitle: "Pizza") { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .failedToRemoveRecipeBecauseInexisting)
            case .success:
                XCTFail()
            }
        }
    }


    func testGivenFailingContextSave_whenRemoveRecipe_thenError() {

        let mockCoreDataContext = CoreDataContextFailureMock(
            isSaveFailing: true,
            isFetchFailing: false
        )
        
        let coreDataStack = CoreDataStack(inMemory: true, operationsContext: mockCoreDataContext)
        
        mockCoreDataContext.coreDataStack = coreDataStack
        
        let recipeCoreDataService = RecipeCoreDataService(coreDataStack: coreDataStack)


        recipeCoreDataService.removeRecipe(recipeTitle: "Pizza") { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .failedToRemoveRecipeFromContext)
            case .success:
                XCTFail()
            }
        }
    }
    
    func testGivenFailingContextFetch_whenGetRecipes_thenError() {

        let mockCoreDataContext = CoreDataContextFailureMock(
            isSaveFailing: false,
            isFetchFailing: true
        )
        
        let coreDataStack = CoreDataStack(inMemory: true, operationsContext: mockCoreDataContext)
        
        mockCoreDataContext.coreDataStack = coreDataStack
        
        let recipeCoreDataService = RecipeCoreDataService(coreDataStack: coreDataStack)


        recipeCoreDataService.getRecipes { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .failedToGetRecipesFromContext)
            case .success:
                XCTFail()
            }
        }
    }
    
    func testGivenFetchRecipesWithBadFormat_whenGetRecipes_thenError() {

        let mockCoreDataContext = CoreDataContextFailureMock(
            isSaveFailing: false,
            isFetchFailing: false
        )
        
        let coreDataStack = CoreDataStack(inMemory: true, operationsContext: mockCoreDataContext)
        
        mockCoreDataContext.coreDataStack = coreDataStack
        
        let recipeCoreDataService = RecipeCoreDataService(coreDataStack: coreDataStack)


        recipeCoreDataService.getRecipes { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .failedToGetRecipesDueToDecodingFailure)
            case .success:
                XCTFail()
            }
        }
    }
    
    
    
    func testGivenFetchRecipesWithIngredientsBadFormat_whenGetRecipes_thenError() {

        let mockCoreDataContext = CoreDataContextFailureMock(
            isSaveFailing: false,
            isFetchFailing: false
        )
        
        let coreDataStack = CoreDataStack(inMemory: true, operationsContext: mockCoreDataContext)
        
        mockCoreDataContext.coreDataStack = coreDataStack
        
        let recipeEntityWithBadFormat = RecipeEntity(context: coreDataStack.wrappedContext)
        recipeEntityWithBadFormat.ingredientsDetails = "Salad" // bad format, not a table
        mockCoreDataContext.recipeEntities = [recipeEntityWithBadFormat]
        
        
        let recipeCoreDataService = RecipeCoreDataService(coreDataStack: coreDataStack)


        recipeCoreDataService.getRecipes { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .failedToGetRecipesDueToDecodingFailure)
            case .success:
                XCTFail()
            }
        }
    }
    
    
    
    func testGivenFetchFailingContext_whenCheckIsRecipeAlreadySaved_thenError() {

        let mockCoreDataContext = CoreDataContextFailureMock(
            isSaveFailing: false,
            isFetchFailing: true
        )
        
        let coreDataStack = CoreDataStack(inMemory: true, operationsContext: mockCoreDataContext)
        
        mockCoreDataContext.coreDataStack = coreDataStack
        
        
        let recipeCoreDataService = RecipeCoreDataService(coreDataStack: coreDataStack)


        recipeCoreDataService.isRecipeAlreadySaved(recipeTitle: "Pizza") { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .failedToGetRecipesFromContext)
            case .success:
                XCTFail()
            }
        }
    }
    
    
    func testGivenFetchFailingContext_whenSaveRecipe_thenError() {

        let mockCoreDataContext = CoreDataContextFailureMock(
            isSaveFailing: false,
            isFetchFailing: true
        )
        
        let coreDataStack = CoreDataStack(inMemory: true, operationsContext: mockCoreDataContext)
        
        mockCoreDataContext.coreDataStack = coreDataStack
        
        
        let recipeCoreDataService = RecipeCoreDataService(coreDataStack: coreDataStack)


        recipeCoreDataService.saveRecipe(
            title: "Pizza",
            ingredients: "Salat",
            ingredientsDetails: [],
            imageUrl: "www.google.com",
            url: "www.google.com",
            yield: 15,
            recipeTime: 20
        ) { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .failedToGetRecipesFromContext)
            case .success:
                XCTFail()
            }
        }
    }
    
    
    
    func testGivenAlreadySavedRecipe_whenSaveRecipe_thenError() {
        
        let coreDataStack = CoreDataStack(inMemory: true, operationsContext: nil)
        
        
        let recipeCoreDataService = RecipeCoreDataService(coreDataStack: coreDataStack)
        
        
        recipeCoreDataService.saveRecipe(
            title: "Pizza",
            ingredients: "Salat",
            ingredientsDetails: ["cheese", "tomato"],
            imageUrl: "www.google.com",
            url: "www.google.com",
            yield: 15,
            recipeTime: 20
        ) { _ in
            recipeCoreDataService.saveRecipe(
                title: "Pizza",
                ingredients: "Salat",
                ingredientsDetails: ["cheese", "tomato"],
                imageUrl: "www.google.com",
                url: "www.google.com",
                yield: 15,
                recipeTime: 20
            ) { result in
                switch result {
                case .failure(let error):
                    XCTAssertEqual(error, .failedToSaveRecipeBecauseAlreadyStored)
                case .success:
                    XCTFail()
                }
            }
        }
    }
    
    
    
    func testGivenFailingSaveContext_whenSaveRecipe_thenError() {
        
        let mockCoreDataContext = CoreDataContextFailureMock(
            isSaveFailing: true,
            isFetchFailing: false
        )
        
        let coreDataStack = CoreDataStack(inMemory: true, operationsContext: mockCoreDataContext)
        
        mockCoreDataContext.coreDataStack = coreDataStack
        
        let recipeEntityWithBadFormat = RecipeEntity(context: coreDataStack.wrappedContext)
        recipeEntityWithBadFormat.ingredientsDetails = "[\"1 large yellow onion, thinly sliced\"]"
        mockCoreDataContext.recipeEntities = [recipeEntityWithBadFormat]
        
        
        let recipeCoreDataService = RecipeCoreDataService(coreDataStack: coreDataStack)
        
        recipeCoreDataService.saveRecipe(
            title: "Pizza",
            ingredients: "Salat",
            ingredientsDetails: ["cheese", "tomato"],
            imageUrl: "www.google.com",
            url: "www.google.com",
            yield: 15,
            recipeTime: 20
        ) { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .contextFailedToSaveRecipe)
            case .success:
                XCTFail()
            }
        }
    }
    
}
