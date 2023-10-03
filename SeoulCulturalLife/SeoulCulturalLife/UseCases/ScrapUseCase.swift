//
//  ScrapUseCase.swift
//  FreeSeoulCulturalLife
//
//  Created by Gundy on 2023/09/25.
//

final class ScrapUseCase: UseCase {
    
    weak var delegate: UseCaseDelegate? = nil
    var container: [Event] = [] {
        didSet {
            delegate?.useCaseDidUpdate(events: container)
        }
    }
    
    func filter(from container: [Event],
                category: Category?) -> [Event] {
        var container = container
        
        if let category {
            container = container.filter { $0.category == category }
        }
        
        return container
    }
}
