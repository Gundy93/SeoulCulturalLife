//
//  EventResponseDTO.swift
//  FreeSeoulCulturalLife
//
//  Created by Gundy on 2023/09/30.
//

import Foundation

struct EventResponseDTO: Decodable {
    
    let culturalEventInfo: EventInfoDTO
    
    enum CodingKeys: String, CodingKey {
        
        case culturalEventInfo
    }
}

struct EventInfoDTO: Decodable {
    let result: [EventDTO]
    
    enum CodingKeys: String, CodingKey {
        
        case result = "RESULT"
    }
}
