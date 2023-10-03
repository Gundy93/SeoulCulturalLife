//
//  ViewModel.swift
//  FreeSeoulCulturalLife
//
//  Created by Gundy on 2023/09/26.
//

import Foundation

class ViewModel: UseCaseDelegate {
    
    private(set) var useCase: UseCase
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
        
        postFilters(GlobalConstant.filterPostName)
    }
    
    func setGu(_ gu: Gu?) {
        self.gu = gu
        
        postFilters(GlobalConstant.filterPostName)
    }
    
    func setIsFree(_ isFree: Bool?) {
        self.isFree = isFree
    }
    
    func setDate(_ date: Date?) {
        self.date = date
    }
    
    func postEvents(_ events: [Event],
                    name: Notification.Name) {
        NotificationCenter.default.post(name: name,
                                        object: useCase.filter(from: events,
                                                               category: category,
                                                               gu: gu,
                                                               isFree: isFree,
                                                               date: date))
    }
    
    func postFilters(_ name: Notification.Name) {
        NotificationCenter.default.post(name: name,
                                        object: (category, gu))
    }
    
    func useCaseDidUpdate(events: [Event]...) {}
}
