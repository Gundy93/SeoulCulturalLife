//
//  UseCase.swift
//  FreeSeoulCulturalLife
//
//  Created by Gundy on 2023/09/25.
//

import Foundation

protocol UseCase: AnyObject {
    
    var delegate: UseCaseDelegate? { get set }
    var container: [Event] { get set }
    
    func filter(from container: [Event], gu: Gu?, isFree: Bool?, date: Date?) -> [Event]
    func setContainer(_ container: [Event])
    func appendEvents(_ events: [Event])
}

extension UseCase {
    
    func filter(from container: [Event], gu: Gu?, isFree: Bool?, date: Date?) -> [Event] {
        var container = container
        
        if let gu {
            container = container.filter { $0.gu == gu }
        }
        if let isFree {
            container = container.filter { $0.isFree == isFree }
        }
        if let date {
            container = container.filter { $0.startDate <= date && $0.endDate >= date }
        }
        
        return container
    }
    
    func setContainer(_ container: [Event]) {
        self.container = container
    }
    
    func appendEvents(_ events: [Event]) {
        container += events
    }
}
