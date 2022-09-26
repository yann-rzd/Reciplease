//
//  CoreDataContextFailureMock.swift
//  RecipleaseTests
//
//  Created by Yann Rouzaud on 26/09/2022.
//

import Foundation
import CoreData
@testable import Reciplease

final class CoreDataContextFailureMock: RecipleaseCoreDataContextProtocol {
    init(isSaveFailing: Bool, isFetchFailing: Bool) {
        self.isSaveFailing = isSaveFailing
        self.isFetchFailing = isFetchFailing
    }
    
    let isSaveFailing: Bool
    let isFetchFailing: Bool
    
    weak var coreDataStack: CoreDataStack?
    
    var recipeEntities: [RecipeEntity]?
    
    func save() throws {
        if isSaveFailing {
            throw MockError.unknownError
        }
    }
    
    func delete(_ object: NSManagedObject) {
        
    }
    
    func fetch<T>(_ request: NSFetchRequest<T>) throws -> [T] where T : NSFetchRequestResult {
        if isFetchFailing {
            throw MockError.unknownError
        } else {
            
            guard let recipeEntities = recipeEntities else {
                let recipeEntity = RecipeEntity(context: coreDataStack!.wrappedContext)
                return [recipeEntity] as! [T]
            }
 
            return recipeEntities as! [T]
        }
    }
}
