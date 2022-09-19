//
//  RecipeUrlProviderFailureMock.swift
//  RecipleaseTests
//
//  Created by Yann Rouzaud on 19/09/2022.
//

import Foundation
@testable import Reciplease

final class RecipeUrlProviderFailureMock: RecipeUrlProviderProtocol {
    func getRecipeUrl(ingredients: [String]) -> URL? {
        return nil
    }
    
    
}
