//
//  DetailViewController.swift
//  FreeSeoulCulturalLife
//
//  Created by Gundy on 2023/10/01.
//

import UIKit
import SafariServices

final class DetailViewController: UIViewController {
    
    private let titleLabel: UILabel = UILabel(font: .preferredFont(forTextStyle: .title1),
                                              numberOfLines: 0)
    private let titleImageView: UIImageView = UIImageView()
    private let categoryStackView: UIStackView = UIStackView(arrangedSubviews: [UILabel(text: Constant.category,
                                                                                        font: .boldSystemFont(ofSize: 20))],
                                                             spacing: 16,
                                                             axis: .horizontal)
    private let dateStackView: UIStackView = UIStackView(arrangedSubviews: [UILabel(text: Constant.date,
                                                                                    font: .boldSystemFont(ofSize: 20))],
                                                         spacing: 16,
                                                         axis: .horizontal)
    private let placeStackView: UIStackView = UIStackView(arrangedSubviews: [UILabel(text: Constant.place,
                                                                                     font: .boldSystemFont(ofSize: 20))],
                                                          spacing: 16,
                                                          axis: .horizontal)
    private let targetStackView: UIStackView = UIStackView(arrangedSubviews: [UILabel(text: Constant.target,
                                                                                      font: .boldSystemFont(ofSize: 20))],
                                                           spacing: 16,
                                                           axis: .horizontal)
    private let linkStackView: UIStackView = UIStackView(arrangedSubviews: [UILabel(text: Constant.link,
                                                                                    font: .boldSystemFont(ofSize: 20))],
                                                         spacing: 16,
                                                         axis: .horizontal)
    private let containerStackView: UIStackView = UIStackView(spacing: 16,
                                                              axis: .vertical,
                                                              alignment: .leading)
    private let scrollView: UIScrollView = UIScrollView()
    private let event: Event
    
    init(event: Event) {
        self.event = event
        
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .systemBackground
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureViewHierarchy()
        configureButtons()
        configureTextContents()
        configureImage()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = Constant.navigationTitle
    }
    
    private func configureViewHierarchy() {
        let safeArea = view.safeAreaLayoutGuide
        let contentLayout = scrollView.contentLayoutGuide
        
        [titleLabel, titleImageView].forEach {
            containerStackView.addArrangedSubview($0)
        }
        [categoryStackView, dateStackView, placeStackView, targetStackView, linkStackView].forEach {
            containerStackView.addArrangedSubview($0)
            $0.arrangedSubviews.first?.setContentHuggingPriority(.required,
                                                                 for: .horizontal)
        }
        scrollView.addSubview(containerStackView)
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor,
                                            constant: 20),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor,
                                               constant: -20),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,
                                                constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,
                                                 constant: -16),
            contentLayout.widthAnchor.constraint(equalTo: view.widthAnchor,
                                                 constant: -32),
            titleImageView.heightAnchor.constraint(equalTo: safeArea.heightAnchor,
                                                   multiplier: 0.7),
            containerStackView.topAnchor.constraint(equalTo: contentLayout.topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: contentLayout.bottomAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: contentLayout.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: contentLayout.trailingAnchor)
        ])
    }
    
    private func configureButtons() {
        let portalLinkButton = UIButton(primaryAction: makeHyperLinkAction(event.portal),
                                        title: Constant.portal)
        
        portalLinkButton.titleLabel?.font = .systemFont(ofSize: 17)
        linkStackView.addArrangedSubview(portalLinkButton)
        
        if let homePage = event.homePage {
            let homePageButton = UIButton(primaryAction: makeHyperLinkAction(homePage),
                                          title: Constant.homePage)
            
            homePageButton.titleLabel?.font = .systemFont(ofSize: 17)
            linkStackView.addArrangedSubview(homePageButton)
        }
    }
    
    private func configureTextContents() {
        titleLabel.text = event.title
        titleLabel.lineBreakMode = .byCharWrapping
        categoryStackView.addArrangedSubview(UILabel(text: event.category.rawValue))
        dateStackView.addArrangedSubview(UILabel(text: DateFormatter.shared.dateString(event.startDate,
                                                                                       event.endDate)))
        placeStackView.addArrangedSubview(UILabel(text: event.place,
                                                  numberOfLines: 0))
        targetStackView.addArrangedSubview(UILabel(text: event.useTarget,
                                                   numberOfLines: 0))
        
        if event.player != nil {
            addPlayerStackView()
        }
        if let program = event.program {
            let programLabel = UILabel(text: program,
                                       numberOfLines: 0)
            
            containerStackView.addArrangedSubview(programLabel)
        }
        if let description = event.description {
            let descriptionLabel = UILabel(text: description,
                                           numberOfLines: 0)
            
            containerStackView.addArrangedSubview(descriptionLabel)
        }
    }
    
    private func addPlayerStackView() {
        guard let player = event.player,
              player.isEmpty == false else { return }
        
        let playerStackView: UIStackView = UIStackView(spacing: 16,
                                                       axis: .horizontal)
        let playerLabel =  UILabel(text: player,
                                   numberOfLines: 0)
        
        [UILabel(text: Constant.player,
                 font: .boldSystemFont(ofSize: 20)),
         playerLabel].forEach {
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
                titleImageView.contentMode = .scaleAspectFit
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
        static let player: String = "출연"
        static let navigationTitle: String = "상세 정보"
    }
}
