//
//  UseCaseDelegate.swift
//  FreeSeoulCulturalLife
//
//  Created by Gundy on 2023/09/25.
//

protocol UseCaseDelegate: AnyObject {
    
    func useCaseDidUpdate(events: [Event]...)
}
