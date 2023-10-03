//
//  EventResponseDTO.swift
//  FreeSeoulCulturalLife
//
//  Created by Gundy on 2023/09/30.
//

struct EventResponseDTO: Decodable {
    
    let culturalEventInfo: EventInfoDTO
    
    enum CodingKeys: String, CodingKey {
        
        case culturalEventInfo
    }
}

struct EventInfoDTO: Decodable {
    
    let events: [EventDTO]
    
    enum CodingKeys: String, CodingKey {
        
        case events = "row"
    }
}
