//
//  EventAPIProvider.swift
//  FreeSeoulCulturalLife
//
//  Created by Gundy on 2023/09/30.
//

import Foundation

struct EventAPIProvider: APIProvider {
    
    private let category: String?
    
    var url: URL? {
        var url = "http://openapi.seoul.go.kr:8088/43455350436b6f723639527a636e76/json/culturalEventInfo/1/1/"
        if let category {
            url += "\(category)/"
        }
        
        return URL(string: url)
    }
}
