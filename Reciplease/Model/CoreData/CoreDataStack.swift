//
//  CoreDataStack.swift
//  Reciplease
//
//  Created by Yann Rouzaud on 03/08/2022.
//

import Foundation
import CoreData

final class CoreDataStack {
    
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
    
    private let coreDataPersistentContainerProvider: CoreDataPersistentContainerProvider
}
