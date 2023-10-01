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
    private let networkManager: NetworkManager
    private var isLoaded: Bool = false
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    
    init(viewModel: ViewModel, networkManager: NetworkManager) {
        self.viewModel = viewModel
        self.networkManager = networkManager
        
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
        fetchNewEvents()
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
        listTableView.refreshControl = refreshControl
        refreshControl.addTarget(self,
                                 action: #selector(refresh),
                                 for: .valueChanged)
    }
    
    private func configureDataSource() {
        listDataSource = ListDataSource(tableView: listTableView) { tableView, indexPath, event in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.ListCellIdentifier,
                                                           for: indexPath) as? ListCell else {
                return ListCell()
            }
            let dateText = DateFormatter.shared.dateString(event.startDate,
                                                           event.endDate)
            
            cell.removeImage()
            cell.setText(title: event.title, date: dateText)
            Task { [weak self] in
                cell.setTitleImage(image: await self?.loadImage(url: event.imageLink),
                                   title: event.title) 
            }
            
            return cell
        }
    }
    
    private func loadImage(url: URL?) async -> UIImage? {
        guard let urlString = url?.absoluteString else { return nil }
        
        let key = NSString(string: urlString)
        if let cachedImage = UIImage.cache.object(forKey: key) {
            return cachedImage
        }
        
        guard let data = await networkManager.fetchData(from: url),
              let image = UIImage(data: data) else { return nil }
        
        UIImage.cache.setObject(image, forKey: key)
        
        return image
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
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(fetchNewEvents),
                                               name: GlobalConstant.categoryPostName,
                                               object: nil)
    }
    
    @objc
    private func setSnapshot(_ notification: Notification) {
        guard let events = notification.object as? [Event] else { return }
        Task { [weak self] in
            var snapshot = ListSnapshot()
            
            snapshot.appendSections([0])
            self?.completeFetching(snapshot: snapshot,
                                   events: events)
            self?.refreshControl.endRefreshing()
        }
    }
    
    @objc
    private func addItemsToSnapshot(_ notification: Notification) {
        guard let events = notification.object as? [Event],
              let snapshot = listDataSource?.snapshot() else { return }
        
        if events.isEmpty == false {
            Task { [weak self] in
                self?.completeFetching(snapshot: snapshot,
                                       events: events)
            }
        }
    }
    
    @objc
    private func refresh() {
        isLoaded = false
        Task { [weak self] in
            try await Task.sleep(until: .now + .seconds(0.5))
            self?.fetchNewEvents()
        }
    }
    
    @objc
    private func fetchNewEvents() {
        Task {
            await networkManager.loadNewData(viewModel.category)
        }
    }
    
    private func fetchMoreEvents() {
        Task {
            await networkManager.loadMoreData(viewModel.category)
        }
    }
    
    private func completeFetching(snapshot: ListSnapshot, events: [Event]) {
        var snapshot = snapshot
        
        snapshot.appendItems(events)
        listDataSource?.apply(snapshot)
        isLoaded = true
        fetchMoreIfNeeded()
    }
    
    private func fetchMoreIfNeeded() {
        guard listTableView.contentSize.height < listTableView.bounds.height * 2,
              isLoaded else { return }
        
        isLoaded = false
        fetchMoreEvents()
    }
}

extension ListViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard isLoaded else { return }
        if scrollView.contentOffset.y > scrollView.contentSize.height - (scrollView.bounds.height * 2) {
            
            isLoaded = false
            fetchMoreEvents()
        }
    }
}

extension ListViewController {
    
    enum Constant {
        
        static let navigationTitle: String = "목록"
        static let filterActionImageName: String = "line.3.horizontal.decrease.circle"
        static let ListCellIdentifier: String = "ListCell"
    }
}
