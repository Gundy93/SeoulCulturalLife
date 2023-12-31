//
//  ListViewController.swift
//  FreeSeoulCulturalLife
//
//  Created by Gundy on 2023/09/22.
//

import UIKit

final class ListViewController: EventsViewController {
    
    typealias ListDataSource = UITableViewDiffableDataSource<Int, Event>
    
    private let listTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.register(ListCell.self,
                           forCellReuseIdentifier: Constant.ListCellIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    private var listDataSource: ListDataSource?
    private var isLoaded: Bool = false
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewHierarchy()
        configureTableView()
        configureDataSource()
        addObserver()
        fetchNewEvents()
        configureLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar(Constant.navigationTitle)
    }
    
    private func configureViewHierarchy() {
        let safeArea = view.safeAreaLayoutGuide
        
        [listTableView, noEventsLabel].forEach {
            view.addSubview($0)
        }
        NSLayoutConstraint.activate([
            listTableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            listTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            listTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            listTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            noEventsLabel.centerXAnchor.constraint(equalTo: listTableView.centerXAnchor),
            noEventsLabel.centerYAnchor.constraint(equalTo: listTableView.centerYAnchor)
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
            cell.setText(title: event.title,
                         date: dateText)
            Task { [weak self] in
                cell.setTitleImage(image: await self?.loadImage(url: event.imageLink),
                                   title: event.title) 
            }
            
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
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(fetchNewEvents),
                                               name: GlobalConstant.categoryPostName,
                                               object: nil)
    }
    
    @objc
    private func setSnapshot(_ notification: Notification) {
        guard let events = notification.object as? [Event] else { return }
        
        Task { [weak self] in
            var snapshot = EventSnapshot()
            
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
    
    private func completeFetching(snapshot: EventSnapshot, events: [Event]) {
        var snapshot = snapshot
        
        snapshot.appendItems(events)
        listDataSource?.apply(snapshot)
        
        isLoaded = true
        
        fetchMoreIfNeeded()
        
        noEventsLabel.isHidden = snapshot.numberOfItems > 0
    }
    
    private func fetchMoreIfNeeded() {
        guard listTableView.contentSize.height < listTableView.bounds.height * 2,
              isLoaded else { return }
        
        isLoaded = false
        
        fetchMoreEvents()
    }
    
    private func configureLabel() {
        noEventsLabel.text = Constant.noEvents
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let event = listDataSource?.itemIdentifier(for: indexPath) else { return }
        
        pushDetailViewController(event: event)
        tableView.deselectRow(at: indexPath,
                              animated: true)
    }
}

extension ListViewController {
    
    enum Constant {
        
        static let navigationTitle: String = "목록"
        static let ListCellIdentifier: String = "ListCell"
        static let noEvents: String = "검색 결과가 없습니다."
    }
}
