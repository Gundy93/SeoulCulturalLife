//
//  ScrapCell.swift
//  SeoulCulturalLife
//
//  Created by Gundy on 2023/10/02.
//

import UIKit

final class ScrapCell: UICollectionViewCell {
    
    private let titleImageView: UIImageView = UIImageView()
    private let titleLabel: UILabel = UILabel(font: .preferredFont(forTextStyle: .title3),
                                              textAlignment: .center)
    private let dateLabel: UILabel = UILabel(font: .preferredFont(forTextStyle: .callout),
                                             textAlignment: .center)
    private let containerStackView: UIStackView = UIStackView(spacing: 8,
                                                              axis: .vertical,
                                                              distribution: .fill)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViewHierarchy()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViewHierarchy() {
        [titleImageView, titleLabel, dateLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        contentView.addSubview(containerStackView)

        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
    
    func setText(title: String, date: String) {
        titleLabel.text = title
        dateLabel.text = date
    }
    
    func setTitleImage(image: UIImage?, title: String) {
        Task { [weak self] in
            guard self?.titleLabel.text == title else { return }
            
            self?.titleImageView.image = image
        }
    }
    
    func removeImage() {
        titleImageView.image = nil
    }
}
