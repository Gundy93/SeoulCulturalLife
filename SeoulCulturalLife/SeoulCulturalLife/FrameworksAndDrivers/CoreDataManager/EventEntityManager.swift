//
//  EventEntityManager.swift
//  SeoulCulturalLife
//
//  Created by Gundy on 2023/10/03.
//

import CoreData

struct EventEntityManager: EntityManager {
    
    typealias Domain = Event
    typealias Entity = EventEntity
    
    let container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constant.dataModelName)
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

        return container
    }()
    var entityDescription: NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: Constant.entityName,
                                          in: context)
    }
    
    func creat(entity: Event) {
        guard let description = entityDescription,
              findEntity(entity) == nil else { return }
        let eventEntity = NSManagedObject(entity: description,
                                          insertInto: context)
        
        eventEntity.setValue(entity.title,
                             forKey: Constant.title)
        eventEntity.setValue(entity.category.rawValue,
                             forKey: Constant.category)
        eventEntity.setValue(entity.gu?.rawValue,
                             forKey: Constant.gu)
        eventEntity.setValue(entity.imageLink?.absoluteString,
                             forKey: Constant.imageLink)
        eventEntity.setValue(entity.startDate,
                             forKey: Constant.startDate)
        eventEntity.setValue(entity.endDate,
                             forKey: Constant.endDate)
        eventEntity.setValue(entity.place,
                             forKey: Constant.place)
        eventEntity.setValue(entity.homePage,
                             forKey: Constant.homePage)
        eventEntity.setValue(entity.portal,
                             forKey: Constant.portal)
        eventEntity.setValue(entity.player,
                             forKey: Constant.player)
        eventEntity.setValue(entity.useTarget,
                             forKey: Constant.useTarget)
        eventEntity.setValue(entity.program,
                             forKey: Constant.program)
        eventEntity.setValue(entity.description,
                             forKey: Constant.description)
        eventEntity.setValue(entity.useFee,
                             forKey: Constant.useFee)
        eventEntity.setValue(entity.isFree,
                             forKey: Constant.isFree)
        
        saveContext()
    }
    
    func readEntities() -> [EventEntity] {
        let request = EventEntity.fetchRequest()
        guard let result = try? context.fetch(request) else { return [] }
        
        return result
    }
    
    func update(entity: Event) {}
    
    func delete(entity: Event) {
        guard let entity = findEntity(entity) else { return }
        
        context.delete(entity)
        saveContext()
    }
    
    private func findEntity(_ event: Event) -> EventEntity? {
        let entities = readEntities()
        
        return entities.first {
            $0.imageLink == event.imageLink?.absoluteString
        }
    }
}

extension EventEntityManager {
    
    enum Constant {
        
        static let dataModelName: String = "SeoulCulturalLife"
        static let entityName: String = "EventEntity"
        static let title: String = "title"
        static let category: String = "category"
        static let gu: String = "gu"
        static let imageLink: String = "imageLink" 
        static let startDate: String = "startDate" 
        static let endDate: String = "endDate"
        static let place: String = "place"
        static let homePage: String = "homePage"
        static let portal: String = "portal"
        static let player: String = "player"
        static let useTarget: String = "useTarget" 
        static let program: String = "program"
        static let description: String = "eventDescription"
        static let useFee: String = "useFee"
        static let isFree: String = "isFree"
    }
}
