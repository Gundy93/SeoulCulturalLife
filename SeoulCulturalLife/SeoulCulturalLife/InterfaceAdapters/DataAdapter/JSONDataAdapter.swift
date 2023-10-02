//
//  JSONDataAdapter.swift
//  FreeSeoulCulturalLife
//
//  Created by Gundy on 2023/09/30.
//

import Foundation

struct JSONDataAdapter: DataAdapter {
    
    typealias DataType = Data
    
    var useCase: UseCase
    private let decoder: JSONDecoder = JSONDecoder()
    
    func convertToDomain(_ data: Data) -> [Event] {
        let data = decode(data)
        let events = data.map(toDomain)
        
        return events
    }
    
    private func decode(_ data: Data) -> [EventDTO] {
        guard let decodedData = try? decoder.decode(EventResponseDTO.self, from: data) else { return [] }
        
        return decodedData.culturalEventInfo.events
    }
    
    private func toDomain(_ data: EventDTO) -> Event {
        let category: Category = Category(rawValue: data.category) ?? .etc
        let startDate = DateFormatter.shared.date(from: String(data.startDate.split(separator: Constant.space)[0])) ?? Date()
        let endDate = DateFormatter.shared.date(from: String(data.endDate.split(separator: Constant.space)[0])) ?? Date()
        let event: Event = Event(title: data.title,
                                 category: category,
                                 gu: Gu(rawValue: data.gu ?? String()),
                                 imageLink: URL(string: data.imageLink),
                                 startDate: startDate,
                                 endDate: endDate,
                                 place: data.place,
                                 homePage: data.homePage,
                                 portal: data.portal,
                                 player: data.player,
                                 useTarget: data.useTarget,
                                 program: data.program,
                                 description: data.description,
                                 useFee: data.useFee,
                                 isFree: data.isFree == Constant.free)
        
        return event
    }
}

extension JSONDataAdapter {
    
    enum Constant {
        
        static let space: String = " "
        static let free: String = "무료"
    }
}
