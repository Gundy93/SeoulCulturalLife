//
//  DetailViewController.swift
//  FreeSeoulCulturalLife
//
//  Created by Gundy on 2023/10/01.
//

import UIKit
import SafariServices

final class DetailViewController: UIViewController {
    
    private let titleLabel: UILabel = UILabel(font: .preferredFont(forTextStyle: .largeTitle))
    private let titleImageView: UIImageView = UIImageView()
    private let categoryStackView: UIStackView = UIStackView(arrangedSubviews: [UILabel(text: Constant.category)],
                                                             spacing: 16,
                                                             axis: .horizontal)
    private let dateStackView: UIStackView = UIStackView(arrangedSubviews: [UILabel(text: Constant.date)],
                                                         spacing: 16,
                                                         axis: .horizontal)
    private let placeStackView: UIStackView = UIStackView(arrangedSubviews: [UILabel(text: Constant.place)],
                                                          spacing: 16,
                                                          axis: .horizontal)
    private let targetStackView: UIStackView = UIStackView(arrangedSubviews: [UILabel(text: Constant.target)],
                                                           spacing: 16,
                                                           axis: .horizontal)
    private let linkStackView: UIStackView = UIStackView(arrangedSubviews: [UILabel(text: Constant.link)],
                                                         spacing: 16,
                                                         axis: .horizontal)
    private let containerStackView: UIStackView = UIStackView(spacing: 8,
                                                              axis: .vertical)
    private let event: Event
    
    init(event: Event) {
        self.event = event
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewHierarchy()
        configureButtons()
        configureTextContents()
        configureImage()
    }
    
    private func configureViewHierarchy() {
        let safeArea = view.safeAreaLayoutGuide
        
        [titleLabel, titleImageView].forEach {
            containerStackView.addArrangedSubview($0)
        }
        [categoryStackView, dateStackView, placeStackView, targetStackView, linkStackView].forEach {
            containerStackView.addArrangedSubview($0)
            $0.arrangedSubviews.first?.setContentHuggingPriority(.required,
                                                                 for: .horizontal)
        }
        view.addSubview(containerStackView)
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            containerStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20),
            containerStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            containerStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureButtons() {
        let portalLinkButton = UIButton(primaryAction: makeHyperLinkAction(event.portal),
                                        title: Constant.portal)
        
        linkStackView.addArrangedSubview(portalLinkButton)
        
        if let homePage = event.homePage {
            let homePageButton = UIButton(primaryAction: makeHyperLinkAction(homePage),
                                          title: Constant.homePage)
            
            containerStackView.addArrangedSubview(homePageButton)
            homePageButton.leadingAnchor.constraint(equalTo: portalLinkButton.leadingAnchor).isActive = true
        }
    }
    
    private func configureTextContents() {
        titleLabel.text = event.title
        categoryStackView.addArrangedSubview(UILabel(text: event.category.rawValue))
        dateStackView.addArrangedSubview(UILabel(text: DateFormatter.shared.dateString(event.startDate,
                                                                                       event.endDate)))
        placeStackView.addArrangedSubview(UILabel(text: event.place))
        targetStackView.addArrangedSubview(UILabel(text: event.useTarget))
        
        if let player = event.player {
            addPlayerStackView()
        }
        if let program = event.program {
            containerStackView.addArrangedSubview(UILabel(text: event.program))
        }
        if let description = event.description {
            containerStackView.addArrangedSubview(UILabel(text: event.description))
        }
    }
    
    private func addPlayerStackView() {
        let playerStackView: UIStackView = UIStackView(spacing: 16,
                                                       axis: .horizontal)
        
        [UILabel(text: Constant.player), UILabel(text: event.player)].forEach {
            playerStackView.addArrangedSubview($0)
        }
        containerStackView.addArrangedSubview(playerStackView)
    }
    
    private func configureImage() {
        guard let urlString = event.imageLink?.absoluteString else { return }
        
        let key = NSString(string: urlString)
        if let cachedImage = UIImage.cache.object(forKey: key) {
            Task {
                titleImageView.image = cachedImage
            }
        } else {
            Task {
                try await Task.sleep(until: .now + .seconds(0.5))
                configureImage()
            }
        }
    }
    
    private func makeHyperLinkAction(_ address: String) -> UIAction? {
        guard let url = URL(string: address) else {
            return nil
        }
        let safariViewController = SFSafariViewController(url: url)
        let action = UIAction { [weak self] _ in
            self?.present(safariViewController, animated: true)
        }
        
        return action
    }
}

extension DetailViewController {
    
    enum Constant {
        
        static let category: String = "카테고리"
        static let date: String = "날짜"
        static let place: String = "장소"
        static let target: String = "이용대상"
        static let link: String = "링크"
        static let portal: String = "문화포털"
        static let homePage: String = "홈페이지"
        static let player: String = "출연자"
    }
}
