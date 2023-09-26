//
//  ViewModel.swift
//  FreeSeoulCulturalLife
//
//  Created by Gundy on 2023/09/26.
//

import Foundation

class ViewModel {
    
    private var useCase: UseCase
    private(set) var filters: (gu: Gu?, date: Date?) = (nil, nil)
    
    init(useCase: UseCase) {
        self.useCase = useCase
    }
    
    func setFilter(gu: Gu?, date: Date?) {
        filters = (gu, date)
        post(useCase.container)
    }
    
    private func post(_ events: [Event]) {
        NotificationCenter.default.post(name: Constant.defaultPostName,
                                        object: useCase.filter(from: events,
                                                               gu: filters.gu,
                                                               date: filters.date))
    }
}

extension ViewModel: UseCaseDelegate {
    
    func useCaseDidUpdate(events: [Event]...) {
        guard let events = events.first else { return }
        
        post(events)
    }
}
