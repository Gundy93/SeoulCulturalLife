//
//  Event.swift
//  FreeSeoulCulturalLife
//
//  Created by Gundy on 2023/09/25.
//

import Foundation

struct Event: Hashable {
    
    let title: String
    let category: Category
    let gu: Gu?
    let imageLink: URL?
    let startDate: Date
    let endDate: Date
    let place: String
    let homePage: String?
    let portal: String
    let player: String?
    let useTarget: String
    let program: String?
    let description: String?
}
