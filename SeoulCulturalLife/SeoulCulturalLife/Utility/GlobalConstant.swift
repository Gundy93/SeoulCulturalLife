//
//  Constant.swift
//  FreeSeoulCulturalLife
//
//  Created by Gundy on 2023/09/26.
//

import Foundation

enum GlobalConstant {
    
    typealias Name = Notification.Name
    
    static let defaultPostName: Name = Name("default")
    static let additionPostName: Name = Name("addition")
    static let filterPostName: Name = Name("filter")
    static let categoryPostName: Name = Name("category")
    static let scrapPostName: Name = Name("scrap")
    static let changeScrapedName: Name = Name("changeScraped")
}
