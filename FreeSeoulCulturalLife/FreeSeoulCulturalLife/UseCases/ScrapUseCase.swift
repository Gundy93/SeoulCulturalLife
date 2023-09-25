//
//  ScrapUseCase.swift
//  FreeSeoulCulturalLife
//
//  Created by Gundy on 2023/09/25.
//


struct ScrapUseCase: UseCase {
    
    var delegate: UseCaseDelegate?
    var container: [Event] {
        didSet {
            delegate?.useCaseDidUpdate(events: container)
        }
    }
    var informations: [Event : Information]
}
