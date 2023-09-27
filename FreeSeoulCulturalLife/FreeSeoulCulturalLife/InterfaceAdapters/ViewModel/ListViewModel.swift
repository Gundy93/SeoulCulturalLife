//
//  ListViewModel.swift
//  FreeSeoulCulturalLife
//
//  Created by Gundy on 2023/09/26.
//

import Foundation

final class ListViewModel: ViewModel {
    
    override func useCaseDidUpdate(events: [Event]...) {
        guard events.count > 1,
              let first = events.first,
              let last = events.last else { return }
        let name = first == last ? GlobalConstant.defaultPostName : GlobalConstant.additionPostName
        
        post(events: last, name: name)
    }
}
