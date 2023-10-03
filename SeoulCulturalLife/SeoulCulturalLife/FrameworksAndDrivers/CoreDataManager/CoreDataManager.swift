//
//  CoreDataManager.swift
//  SeoulCulturalLife
//
//  Created by Gundy on 2023/10/03.
//

final class CoreDataManager {
    
    private let entityManager: EventEntityManager = EventEntityManager()
    private let dataAdapter: CoreDataAdapter
    
    init(dataAdapter: CoreDataAdapter) {
        self.dataAdapter = dataAdapter
    }
    
    func loadData() {
        let data = entityManager.readEntities()
        
        dataAdapter.setDatas(data)
    }
    
    func scrap(event: Event) {
        entityManager.creat(entity: event)
    }
    
    func unscrap(event: Event) {
        entityManager.delete(entity: event)
    }
    
    func isScraped(event: Event) -> Bool {
        return entityManager.readEntities().contains { $0.imageLink == event.imageLink?.absoluteString }
    }
}
