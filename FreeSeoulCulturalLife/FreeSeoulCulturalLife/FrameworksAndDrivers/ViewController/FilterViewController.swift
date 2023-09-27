//
//  FilterViewController.swift
//  FreeSeoulCulturalLife
//
//  Created by Gundy on 2023/09/27.
//

import UIKit

final class FilterViewController: UIViewController {
    
    let viewModel: ViewModel
    let categoryStackView: UIStackView = UIStackView(spacing: 8)
    let categoryHeaderLabel: UILabel = UILabel(text: Constant.categoryHeaderText,
                                               font: .systemFont(ofSize: 20,
                                                                 weight: .bold))
    let categoryLabel: UILabel = UILabel()
    let guHeaderLabel: UILabel = UILabel(text: Constant.guHeaderText,
                                         font: .systemFont(ofSize: 20,
                                                           weight: .bold))
    let guLabel: UILabel = UILabel()
    let dateHeaderLabel: UILabel = UILabel(text: Constant.dateHeaderText,
                                           font: .systemFont(ofSize: 20,
                                                             weight: .bold))
    let dateSegmentedControl: UISegmentedControl = UISegmentedControl(items: [Constant.notSelected, Constant.selected])
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        
        return datePicker
    }()
    
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
        
        addObserver()
        configureSegmentedControl()
    }

    private func addObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setTexts),
                                               name: GlobalConstant.filterPostName,
                                               object: nil)
    }

    @objc
    private func setTexts(_ notification: Notification) {
        guard let (category, gu) = notification.object as? (Category?, Gu?) else { return }
        let categoryText = category?.rawValue
        let guText = gu?.rawValue
        
        categoryLabel.text = category == nil ? Constant.notSelected : categoryText
        guLabel.text = gu == nil ? Constant.notSelected : guText
    }
    
    private func configureSegmentedControl() {
        dateSegmentedControl.addTarget(self,
                                       action: #selector(toggleDatePicker),
                                       for: .valueChanged)
    }

    @objc
    private func toggleDatePicker(_ segmentedControl: UISegmentedControl) {
        datePicker.isEnabled = segmentedControl.selectedSegmentIndex != 0
    }
}

extension FilterViewController {
    
    enum Constant {
        
        static let categoryHeaderText: String = "분류"
        static let guHeaderText: String = "구"
        static let dateHeaderText: String = "날짜"
        static let notSelected: String = "선택 안 함"
        static let selected: String = "선택"
    }
}
