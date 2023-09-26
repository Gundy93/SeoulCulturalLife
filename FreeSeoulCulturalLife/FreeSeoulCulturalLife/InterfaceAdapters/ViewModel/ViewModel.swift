//
//  ViewModel.swift
//  FreeSeoulCulturalLife
//
//  Created by Gundy on 2023/09/26.
//

import Foundation

class ViewModel: UseCaseDelegate {
    
    private var useCase: UseCase
    private(set) var filters: (gu: Gu?, date: Date?) = (nil, nil)
    
    init(useCase: UseCase) {
        self.useCase = useCase
    }
    
    func setFilter(gu: Gu?, date: Date?) {
        filters = (gu, date)
        post(events: useCase.container)
    }
    
    func post(events: [Event], name: Notification.Name = Constant.defaultPostName) {
        NotificationCenter.default.post(name: name,
                                        object: useCase.filter(from: events,
                                                               gu: filters.gu,
                                                               date: filters.date))
    }
    
    func useCaseDidUpdate(events: [Event]...) {
        guard let events = events.first else { return }
        
        post(events: events)
    }
}
