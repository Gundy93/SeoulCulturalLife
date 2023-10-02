//
//  EventsViewController.swift
//  SeoulCulturalLife
//
//  Created by Gundy on 2023/10/02.
//

import UIKit

class EventsViewController: UIViewController {
    
    typealias EventSnapshot = NSDiffableDataSourceSnapshot<Int, Event>
    
    let viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePresentStyle()
    }
    
    private func configurePresentStyle() {
        modalPresentationStyle = .popover
        view.backgroundColor = .systemBackground
    }
    
    func configureNavigationBar(_ title: String) {
        navigationItem.title = title
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: Constant.filterActionImageName),
                                                            primaryAction: presentFilterAction())
    }
    
    private func presentFilterAction() -> UIAction {
        let action = UIAction() { [weak self] _ in
            guard let self else { return }
            let filterViewController = FilterViewController(viewModel: self.viewModel)
            
            self.present(UINavigationController(rootViewController: filterViewController), animated: true)
        }
        
        return action
    }
    
    func loadImage(url: URL?) async -> UIImage? {
        guard let urlString = url?.absoluteString else { return nil }
        let key = NSString(string: urlString)
        
        return UIImage.cache.object(forKey: key)
    }
}

extension EventsViewController {
    
    enum Constant {
        
        static let filterActionImageName: String = "line.3.horizontal.decrease.circle"
    }
}
