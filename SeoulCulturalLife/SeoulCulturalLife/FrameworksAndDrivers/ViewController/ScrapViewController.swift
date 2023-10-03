//
//  ScrapViewController.swift
//  SeoulCulturalLife
//
//  Created by Gundy on 2023/10/02.
//

import UIKit

final class ScrapViewController: EventsViewController {
    
    typealias ScrapDataSource = UICollectionViewDiffableDataSource<Int, Event>
    
    private var scrapCollectionView: UICollectionView?
    private var scrapDataSource: ScrapDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addObserver()
        configureCollectionView()
        configureDataSource()
        configureViewHierarchy()
        coreDataManager.loadData()
        configureLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar(Constant.navigationTitle)
    }
    
    private func configureCollectionView() {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: makeScrapLayout())
        
        collectionView.delegate = self
        collectionView.register(ScrapCell.self,
                                forCellWithReuseIdentifier: Constant.ScrapCellIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        scrapCollectionView = collectionView
    }
    
    private func makeScrapLayout() -> UICollectionViewLayout {
        let provider = {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalHeight(1)))
            
            let containerGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .fractionalHeight(1/3)),
                subitems: [item])
            
            return NSCollectionLayoutSection(group: containerGroup)
        }
        
        return UICollectionViewCompositionalLayout(sectionProvider: provider)
    }
    
    private func configureDataSource() {
        guard let scrapCollectionView else { return }
        
        scrapDataSource = ScrapDataSource(collectionView: scrapCollectionView) { collectionView, indexPath, event in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.ScrapCellIdentifier,
                                                                for: indexPath) as? ScrapCell else {
                return ScrapCell()
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
    
    private func configureViewHierarchy() {
        let safeArea = view.safeAreaLayoutGuide
        guard let scrapCollectionView else { return }
        
        [scrapCollectionView, noEventsLabel].forEach {
            view.addSubview($0)
        }
        NSLayoutConstraint.activate([
            scrapCollectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrapCollectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            scrapCollectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrapCollectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            noEventsLabel.centerXAnchor.constraint(equalTo: scrapCollectionView.centerXAnchor),
            noEventsLabel.centerYAnchor.constraint(equalTo: scrapCollectionView.centerYAnchor)
        ])
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setSnapshot),
                                               name: GlobalConstant.scrapPostName,
                                               object: nil)
    }
    
    @objc
    private func setSnapshot(_ notification: Notification) {
        guard let events = notification.object as? [Event] else { return }
        
        Task { [weak self] in
            var snapshot = EventSnapshot()
            
            snapshot.appendSections([0])
            snapshot.appendItems(events)
            
            self?.scrapDataSource?.apply(snapshot)
            self?.noEventsLabel.isHidden = snapshot.numberOfItems > 0
        }
    }
    
    private func configureLabel() {
        noEventsLabel.text = Constant.noEvents
    }
}

extension ScrapViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let event = scrapDataSource?.itemIdentifier(for: indexPath) else { return }
        
        let detailViewController = DetailViewController(event: event,
                                                        isScraped: coreDataManager.isScraped(event: event))
        let navigationController = tabBarController?.navigationController
        
        navigationController?.pushViewController(detailViewController,
                                                 animated: true)
        collectionView.deselectItem(at: indexPath,
                                    animated: true)
    }
}

extension ScrapViewController {
    
    enum Constant {
        
        static let navigationTitle: String = "스크랩"
        static let ScrapCellIdentifier: String = "ScrapCell"
        static let noEvents: String = "스크랩이 없습니다."
    }
}
