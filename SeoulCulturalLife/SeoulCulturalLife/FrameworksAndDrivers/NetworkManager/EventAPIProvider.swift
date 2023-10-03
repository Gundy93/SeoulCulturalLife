//
//  EventAPIProvider.swift
//  FreeSeoulCulturalLife
//
//  Created by Gundy on 2023/09/30.
//

import Foundation

struct EventAPIProvider: APIProvider {
    
    private let category: String?
    private let startIndex: Int
    private var endIndex: Int {
        return startIndex + 99
    }
    var url: URL? {
        var url = "http://openapi.seoul.go.kr:8088/43455350436b6f723639527a636e76/json/culturalEventInfo/\(startIndex)/\(endIndex)/"
        
        if let category {
            url += "\(category)/"
        }
        
        return URL(string: url)
    }
    
    init(category: String?, startIndex: Int) {
        self.category = category
        self.startIndex = startIndex
    }
}
