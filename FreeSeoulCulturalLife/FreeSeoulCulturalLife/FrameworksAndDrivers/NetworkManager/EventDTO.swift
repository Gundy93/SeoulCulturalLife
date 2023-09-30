//
//  EventDTO.swift
//  FreeSeoulCulturalLife
//
//  Created by Gundy on 2023/09/30.
//

import Foundation

struct EventDTO: Decodable {
    
    let title: String
    let category: String
    let gu: String?
    let imageLink: String
    let startDate: String
    let endDate: String
    let place: String
    let homePage: String?
    let portal: String
    let player: String?
    let useTarget: String
    let program: String?
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "TITLE"
        case category = "CODENAME"
        case gu = "GUNAME"
        case imageLink = "MAIN_IMG"
        case startDate = "STRTDATE"
        case endDate = "END_DATE"
        case place = "PLACE"
        case homePage = "ORG_LINK"
        case portal = "HMPG_ADDR"
        case player = "PLAYER"
        case useTarget = "USE_TRGT"
        case program = "PROGRAM"
        case description = "ETC_DESC"
    }
}
