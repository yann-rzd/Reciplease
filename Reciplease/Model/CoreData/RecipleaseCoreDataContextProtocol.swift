//
//  RecipleaseCoreDataContextProtocol.swift
//  Reciplease
//
//  Created by Yann Rouzaud on 19/09/2022.
//


import CoreData

protocol RecipleaseCoreDataContextProtocol {
    func save() throws
    func delete(_ object: NSManagedObject)
    func fetch<T>(_ request: NSFetchRequest<T>) throws -> [T] where T : NSFetchRequestResult
}
