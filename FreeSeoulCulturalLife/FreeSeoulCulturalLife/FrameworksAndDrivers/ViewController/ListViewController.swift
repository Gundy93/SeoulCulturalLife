//
//  ListViewController.swift
//  FreeSeoulCulturalLife
//
//  Created by Gundy on 2023/09/22.
//

import UIKit

final class ListViewController: UIViewController {
    
    typealias ListDataSource = UITableViewDiffableDataSource<Int, Event>
    typealias ListSnapShot = NSDiffableDataSourceSnapshot<Int, Event>
    
    private var viewModel: ViewModel
    private var listTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    private var listDataSource: ListDataSource?
    
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
        
        configureNavigationBar()
        configureViewHierarchy()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "목록"
    }
    
    private func configureViewHierarchy() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(listTableView)
        NSLayoutConstraint.activate([
            listTableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            listTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            listTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            listTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
}
