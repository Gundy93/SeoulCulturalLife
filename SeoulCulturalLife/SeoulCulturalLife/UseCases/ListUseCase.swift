//
//  ListUseCase.swift
//  FreeSeoulCulturalLife
//
//  Created by Gundy on 2023/09/25.
//


class ListUseCase: UseCase {
    
    weak var delegate: UseCaseDelegate? = nil
    var container: [Event] = [] {
        didSet {
            delegate?.useCaseDidUpdate(events: container, current)
        }
    }
    var current: [Event] = []
    
    func filter(from container: [Event], category: Category?) -> [Event] {
        return container
    }
    
    func setContainer(_ container: [Event]) {
        current = container
        self.container = container
    }
    
    func appendEvents(_ events: [Event]) {
        current = events
        container += events
    }
}
