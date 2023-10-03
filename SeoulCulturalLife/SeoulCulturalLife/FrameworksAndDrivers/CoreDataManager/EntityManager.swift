//
//  EntityManager.swift
//  SeoulCulturalLife
//
//  Created by Gundy on 2023/10/03.
//

import CoreData

protocol EntityManager {
    
    associatedtype Domain
    associatedtype Entity
    
    var container: NSPersistentContainer { get }
    var context: NSManagedObjectContext { get }
    var entityDescription: NSEntityDescription? { get }
    
    func saveContext()
    func creat(entity: Domain)
    func readEntities() -> [Entity]
    func update(entity: Domain)
    func delete(entity: Domain)
}

extension EntityManager {
    
    var context: NSManagedObjectContext {
        return container.viewContext
    }
    
    func saveContext() {
        guard context.hasChanges else { return }
        
        try? context.save()
    }
}
