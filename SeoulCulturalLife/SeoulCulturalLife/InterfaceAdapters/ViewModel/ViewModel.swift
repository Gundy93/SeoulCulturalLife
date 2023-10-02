//
//  ViewModel.swift
//  FreeSeoulCulturalLife
//
//  Created by Gundy on 2023/09/26.
//

import Foundation

class ViewModel: UseCaseDelegate {
    
    private var useCase: UseCase
    private(set) var category: Category? = nil
    private(set) var gu: Gu? = nil
    private(set) var isFree: Bool? = nil
    private(set) var date: Date? = nil
    
    init(useCase: UseCase) {
        self.useCase = useCase
        useCase.delegate = self
    }
    
    func setCategory(_ category: Category?) {
        self.category = category
        postFilters()
    }
    
    func setGu(_ gu: Gu?) {
        self.gu = gu
        postFilters()
        postEvents(useCase.container, name: GlobalConstant.defaultPostName)
    }
    
    func setIsFree(_ isFree: Bool?) {
        self.isFree = isFree
        postEvents(useCase.container, name: GlobalConstant.defaultPostName)
    }
    
    func setDate(_ date: Date?) {
        self.date = date
        postEvents(useCase.container, name: GlobalConstant.defaultPostName)
    }
    
    private func postFilters() {
        NotificationCenter.default.post(name: GlobalConstant.filterPostName,
                                        object: (category, gu))
    }
    
    func postEvents(_ events: [Event], name: Notification.Name) {
        NotificationCenter.default.post(name: name,
                                        object: useCase.filter(from: events,
                                                               gu: gu,
                                                               isFree: isFree,
                                                               date: date))
    }
    
    func useCaseDidUpdate(events: [Event]...) {
        guard let events = events.first else { return }
        
        postEvents(events, name: GlobalConstant.defaultPostName)
    }
}
