//
//  ListCell.swift
//  FreeSeoulCulturalLife
//
//  Created by Gundy on 2023/09/27.
//

import UIKit

final class ListCell: UITableViewCell {
    
    private let titleLabel: UILabel = UILabel(font: .preferredFont(forTextStyle: .title3))
    private let dateLabel: UILabel = UILabel(font: .preferredFont(forTextStyle: .callout))
    private let titleImageView: UIImageView = UIImageView()
    private let labelStackView: UIStackView = UIStackView(spacing: 8,
                                                          axis: .vertical,
                                                          distribution: .fillEqually)
    private let containerStackView: UIStackView = UIStackView(spacing: 8,
                                                              axis: .horizontal,
                                                              distribution: .fill)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configure()
        configureViewHierarchy()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        accessoryType = .disclosureIndicator
    }

    private func configureViewHierarchy() {
        [titleLabel, dateLabel].forEach {
            labelStackView.addArrangedSubview($0)
            $0.setContentHuggingPriority(.required,
                                         for: .vertical)
        }
        [titleImageView, labelStackView].forEach { containerStackView.addArrangedSubview($0) }
        contentView.addSubview(containerStackView)

        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            titleImageView.widthAnchor.constraint(equalTo: titleImageView.heightAnchor)
        ])
    }
    
    func setText(title: String, date: String) {
        titleLabel.text = title
        dateLabel.text = date
    }
    
    func setTitleImage(_ image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            self?.titleImageView.image = image
        }
    }
}
