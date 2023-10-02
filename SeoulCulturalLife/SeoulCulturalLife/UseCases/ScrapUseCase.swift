//
//  ScrapUseCase.swift
//  FreeSeoulCulturalLife
//
//  Created by Gundy on 2023/09/25.
//


class ScrapUseCase: UseCase {
    
    weak var delegate: UseCaseDelegate? = nil
    var container: [Event] = [] {
        didSet {
            delegate?.useCaseDidUpdate(events: container)
        }
    }
}
