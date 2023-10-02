//
//  ScrapViewController.swift
//  SeoulCulturalLife
//
//  Created by Gundy on 2023/10/02.
//

import UIKit

final class ScrapViewController: EventsViewController {
    
    typealias ScrapDataSource = UICollectionViewDiffableDataSource<Int, Event>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar(Constant.navigationTitle)
    }
}

extension ScrapViewController {
    
    enum Constant {
        
        static let navigationTitle: String = "스크랩"
    }
}
