//
//  ListUseCase.swift
//  FreeSeoulCulturalLife
//
//  Created by Gundy on 2023/09/25.
//


struct ListUseCase: UseCase {
    
    var delegate: UseCaseDelegate?
    var container: [Event] = [] {
        didSet {
            delegate?.useCaseDidUpdate(events: container, current)
        }
    }
    var informations: [Event: Information] = [:]
    var current: [Event] = []
    
    mutating func setContainer(_ container: [Event]) {
        current = container
        self.container = container
    }
    
    mutating func appendEvents(_ events: [Event]) {
        current = events
        container += events
    }
}
