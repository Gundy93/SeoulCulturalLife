//
//  EntityManager.swift
//  SeoulCulturalLife
//
//  Created by Gundy on 2023/10/03.
//

import CoreData

protocol EntityManager {
    
    associatedtype Entity
    
    var container: NSPersistentContainer { get }
    var context: NSManagedObjectContext { get }
    var entityDescription: NSEntityDescription? { get }
    
    func saveContext()
    func creat(entity: Entity)
    func readEntities() -> [Entity]
    func update(entity: Entity)
    func delete(entity: Entity)
}

extension EntityManager {
    
    func saveContext() {
        guard context.hasChanges else { return }
        
        try? context.save()
    }
}
