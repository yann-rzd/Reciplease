//
//  CoreDataPersistentContainerProvider.swift
//  Reciplease
//
//  Created by Yann Rouzaud on 10/10/2022.
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
