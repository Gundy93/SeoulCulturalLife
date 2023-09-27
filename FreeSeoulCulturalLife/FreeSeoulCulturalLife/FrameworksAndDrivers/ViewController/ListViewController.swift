//
//  ListViewController.swift
//  FreeSeoulCulturalLife
//
//  Created by Gundy on 2023/09/22.
//

import UIKit

final class ListViewController: UIViewController {
    
    typealias ListDataSource = UITableViewDiffableDataSource<Int, Event>
    typealias ListSnapshot = NSDiffableDataSourceSnapshot<Int, Event>
    
    private let viewModel: ViewModel
    private let listTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.register(ListCell.self,
                           forCellReuseIdentifier: Constant.ListCellIdentifier)
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
        configureTableView()
        configureDataSource()
        addObserver()
    }
    
    private func configurePresentStyle() {
        modalPresentationStyle = .popover
        view.backgroundColor = .systemBackground
    }
    
    private func configureNavigationBar() {
        navigationItem.title = Constant.navigationTitle
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
    
    private func configureTableView() {
        listTableView.delegate = self
    }
    
    private func configureDataSource() {
        listDataSource = ListDataSource(tableView: listTableView) { tableView, indexPath, event in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.ListCellIdentifier,
                                                           for: indexPath) as? ListCell else {
                return ListCell()
            }
            let startDate: String = DateFormatter.shared.string(from: event.startDate)
            let endDate: String = DateFormatter.shared.string(from: event.endDate)
            let dateText = startDate == endDate ? startDate : "\(startDate) ~ \(endDate)"
            
            cell.setText(title: event.title, date: dateText)
            
            return cell
        }
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setSnapshot),
                                               name: GlobalConstant.defaultPostName,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(addItemsToSnapshot),
                                               name: GlobalConstant.additionPostName,
                                               object: nil)
    }
    
    @objc
    private func setSnapshot(_ notification: Notification) {
        guard let events = notification.object as? [Event] else { return }
        var snapshot = ListSnapshot()
        
        snapshot.appendSections([0])
        snapshot.appendItems(events)
        listDataSource?.apply(snapshot)
    }
    
    @objc
    private func addItemsToSnapshot(_ notification: Notification) {
        guard let events = notification.object as? [Event],
              var snapshot = listDataSource?.snapshot() else { return }
        
        snapshot.appendItems(events)
        listDataSource?.apply(snapshot)
    }
}

extension ListViewController: UITableViewDelegate {}

extension ListViewController {
    
    enum Constant {
        
        static let navigationTitle: String = "목록"
        static let filterActionImageName: String = "line.3.horizontal.decrease.circle"
        static let ListCellIdentifier: String = "ListCell"
    }
}
