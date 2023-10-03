//
//  EventsTabBarController.swift
//  SeoulCulturalLife
//
//  Created by Gundy on 2023/10/03.
//

import UIKit

final class EventsTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBar()
    }
    
    private func configureTabBar() {
        let listUseCase = ListUseCase()
        let scrapUseCase = ScrapUseCase()
        let listViewModel = ListViewModel(useCase: listUseCase)
        let scrapViewModel = ScrapViewModel(useCase: scrapUseCase)
        let jsonAdapter = JSONDataAdapter(useCase: listUseCase)
        let coreDataAdapter = CoreDataAdapter(useCase: scrapUseCase)
        let networkManager = NetworkManager(dataAdapter: jsonAdapter)
        let coreDataManager = CoreDataManager(dataAdapter: coreDataAdapter)
        let listViewController = ListViewController(viewModel: listViewModel,
                                                    networkManager: networkManager,
                                                    coreDataManager: coreDataManager)
        let scrapViewController = ScrapViewController(viewModel: scrapViewModel,
                                                      networkManager: networkManager,
                                                      coreDataManager: coreDataManager)
        
        listViewController.tabBarItem.image = UIImage(systemName: Constant.listImageName)
        scrapViewController.tabBarItem.image = UIImage(systemName: Constant.scrapImageName)
        
        setViewControllers([UINavigationController(rootViewController: listViewController),
                            UINavigationController(rootViewController: scrapViewController)],
                           animated: false)
    }
}

extension EventsTabBarController {
    
    enum Constant {
        
        static let listImageName: String = "list.bullet"
        static let scrapImageName: String = "paperclip"
    }
}
