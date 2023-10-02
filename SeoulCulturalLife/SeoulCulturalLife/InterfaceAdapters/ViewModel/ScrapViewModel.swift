//
//  ScrapViewModel.swift
//  SeoulCulturalLife
//
//  Created by Gundy on 2023/10/02.
//

import Foundation

final class ScrapViewModel: ViewModel {
    
    override func setCategory(_ category: Category?) {
        super.setCategory(category)
        
        postEvents(useCase.container,
                   name: GlobalConstant.scrapFilterPostName)
    }
    
    override func setGu(_ gu: Gu?) {
        super.setGu(gu)
        
        postEvents(useCase.container,
                   name: GlobalConstant.scrapFilterPostName)
    }
    
    override func setIsFree(_ isFree: Bool?) {
        super.setIsFree(isFree)
        
        postEvents(useCase.container,
                   name: GlobalConstant.scrapFilterPostName)
    }
    
    override func setDate(_ date: Date?) {
        super.setDate(date)
        
        postEvents(useCase.container,
                   name: GlobalConstant.scrapFilterPostName)
    }
    
    override func useCaseDidUpdate(events: [Event]...) {
        guard let first = events.first else { return }
        
        postEvents(first, name: GlobalConstant.scrapPostName)
    }
}
