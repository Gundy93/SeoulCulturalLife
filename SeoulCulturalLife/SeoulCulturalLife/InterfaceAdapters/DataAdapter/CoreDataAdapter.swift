//
//  CoreDataAdapter.swift
//  SeoulCulturalLife
//
//  Created by Gundy on 2023/10/03.
//

import Foundation

struct CoreDataAdapter: DataAdapter {
    
    typealias DataType = [EventEntity]
    
    var useCase: UseCase
    
    func convertToDomain(_ data: [EventEntity]) -> [Event] {
        return data.compactMap(entityToDomain)
    }
    
    private func entityToDomain(_ entity: EventEntity) -> Event? {
        guard let title = entity.title,
              let categoryName = entity.category,
              let category = Category(rawValue: categoryName),
              let imageLink = entity.imageLink,
              let startDate = entity.startDate,
              let endDate = entity.endDate,
              let place = entity.place,
              let portal = entity.portal,
              let useTarget = entity.useTarget else { return nil }
        
        return Event(title: title,
                     category: category,
                     gu: Gu(rawValue: entity.gu ?? String()),
                     imageLink: URL(string: imageLink),
                     startDate: startDate,
                     endDate: endDate,
                     place: place,
                     homePage: entity.homePage,
                     portal: portal,
                     player: entity.player,
                     useTarget: useTarget,
                     program: entity.program,
                     description: entity.eventDescription,
                     useFee: entity.useFee,
                     isFree: entity.isFree)
    }
}
