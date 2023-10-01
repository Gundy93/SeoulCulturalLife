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
    private let portalLinkButton: UIButton = UIButton(title: Constant.portal)
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
        linkStackView.addArrangedSubview(portalLinkButton)
        view.addSubview(containerStackView)
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            containerStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20),
            containerStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            containerStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16)
        ])
    }
}

extension DetailViewController {
    
    enum Constant {
        
        static let category: String = "카테고리: "
        static let date: String = "날짜: "
        static let place: String = "장소: "
        static let target: String = "이용대상: "
        static let link: String = "링크: "
        static let portal: String = "문화포털상세URL"
    }
}
