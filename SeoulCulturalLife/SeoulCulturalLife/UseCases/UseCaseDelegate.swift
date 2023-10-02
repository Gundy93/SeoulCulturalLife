//
//  UseCaseDelegate.swift
//  FreeSeoulCulturalLife
//
//  Created by Gundy on 2023/09/25.
//

import Foundation

protocol UseCaseDelegate: AnyObject {
    
    func useCaseDidUpdate(events: [Event]...)
}
