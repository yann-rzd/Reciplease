//
//  CoreDataStack.swift
//  Reciplease
//
//  Created by Yann Rouzaud on 03/08/2022.
//

import Foundation
import CoreData

final class CoreDataPersistentContainerProvider {
    
    init(inMemory: Bool = false) {
       
        let container = NSPersistentContainer(name: "Reciplease")

        if inMemory {
            let persistentStoreDescription = NSPersistentStoreDescription()
            persistentStoreDescription.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [persistentStoreDescription]
        }
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in })
        
        self.persistentContainer = container
    }
    
    
    let persistentContainer: NSPersistentContainer
}

final class CoreDataStack {

    // MARK: - PUBLIC: properties
    
    
    private let coreDataPersistentContainerProvider: CoreDataPersistentContainerProvider
    
    
    
    init(
        inMemory: Bool = false,
        operationsContext: RecipleaseCoreDataContextProtocol? = nil
    ) {
        self.coreDataPersistentContainerProvider = CoreDataPersistentContainerProvider(inMemory: inMemory)
        self.operationsContext = operationsContext ?? coreDataPersistentContainerProvider.persistentContainer.viewContext
    }
    
    /// save fetch delete (can be injected for testing)
    let operationsContext: RecipleaseCoreDataContextProtocol
    
    
    
    /// create entity (no need to be injected for testing)
    var wrappedContext: NSManagedObjectContext {
        coreDataPersistentContainerProvider.persistentContainer.viewContext
    }

 
}

enum MockError: Error {
    case unknownError
}

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
