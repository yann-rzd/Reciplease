//
//  CoreDataStack.swift
//  Reciplease
//
//  Created by Yann Rouzaud on 03/08/2022.
//

import Foundation
import CoreData

final class CoreDataStack {

    // MARK: - PUBLIC: properties
    
    static let sharedInstance = CoreDataStack()
    
    var viewContext: NSManagedObjectContext {
        return CoreDataStack.sharedInstance.persistentContainer.viewContext
    }

    // MARK: - Private

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Reciplease")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}
