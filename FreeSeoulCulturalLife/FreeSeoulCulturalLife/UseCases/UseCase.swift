//
//  UseCase.swift
//  FreeSeoulCulturalLife
//
//  Created by Gundy on 2023/09/25.
//

import Foundation

protocol UseCase {
    
    var delegate: UseCaseDelegate? { get set }
    var container: [Event] { get set }
    var informations: [Event: Information] { get set }
    
    func filter(from container: [Event], gu: Gu?, date: Date?) -> [Event]
}

extension UseCase {
    
    func filter(from container: [Event], gu: Gu?, date: Date?) -> [Event] {
        switch (gu, date) {
        case (nil, nil):
            return container
        case (nil, _):
            guard let date else { return container }
            return container.filter { $0.startDate <= date && $0.endDate >= date }
        case (_, nil):
            guard let gu else { return container }
            return container.filter { $0.gu == gu }
        default:
            guard let gu,
                  let date else { return container }
            return container.filter { $0.gu == gu && $0.startDate <= date && $0.endDate >= date }
        }
    }
}
