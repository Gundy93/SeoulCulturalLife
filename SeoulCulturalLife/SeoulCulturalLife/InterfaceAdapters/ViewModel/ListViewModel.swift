//
//  ListViewModel.swift
//  FreeSeoulCulturalLife
//
//  Created by Gundy on 2023/09/26.
//

import Foundation

final class ListViewModel: ViewModel {
    
    override func setCategory(_ category: Category?) {
        super.setCategory(category)
        
        NotificationCenter.default.post(name: GlobalConstant.categoryPostName,
                                        object: nil)
    }
    
    override func setGu(_ gu: Gu?) {
        super.setGu(gu)
        
        postEvents(useCase.container,
                   name: GlobalConstant.defaultPostName)
    }
    
    override func setIsFree(_ isFree: Bool?) {
        super.setIsFree(isFree)
        
        postEvents(useCase.container,
                   name: GlobalConstant.defaultPostName)
    }
    
    override func setDate(_ date: Date?) {
        super.setDate(date)
        
        postEvents(useCase.container,
                   name: GlobalConstant.defaultPostName)
    }
    
    override func useCaseDidUpdate(events: [Event]...) {
        guard events.count > 1,
              let first = events.first,
              let last = events.last else { return }
        let name = first == last ? GlobalConstant.defaultPostName : GlobalConstant.additionPostName
        
        postEvents(last,
                   name: name)
    }
}
