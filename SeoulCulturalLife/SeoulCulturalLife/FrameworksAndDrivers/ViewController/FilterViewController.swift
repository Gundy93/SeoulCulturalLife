//
//  FilterViewController.swift
//  FreeSeoulCulturalLife
//
//  Created by Gundy on 2023/09/27.
//

import UIKit

final class FilterViewController: UIViewController {
    
    let viewModel: ViewModel
    let categoryStackView: UIStackView = UIStackView(axis: .horizontal)
    let categoryHeaderLabel: UILabel = UILabel(text: Constant.categoryHeaderText,
                                               font: .systemFont(ofSize: 20,
                                                                 weight: .bold))
    let categoryLabel: UILabel = UILabel()
    let categoryButton: UIButton = UIButton(primaryAction: nil,
                                            image: UIImage(systemName: Constant.buttonImageName))
    let guStackView: UIStackView = UIStackView(axis: .horizontal)
    let guHeaderLabel: UILabel = UILabel(text: Constant.guHeaderText,
                                         font: .systemFont(ofSize: 20,
                                                           weight: .bold))
    let guLabel: UILabel = UILabel()
    let guButton: UIButton = UIButton(primaryAction: nil,
                                      image: UIImage(systemName: Constant.buttonImageName))
    let feeStackView: UIStackView = UIStackView(axis: .horizontal)
    let feeHeaderLabel: UILabel = UILabel(text: Constant.feeHeaderText,
                                         font: .systemFont(ofSize: 20,
                                                           weight: .bold))
    let feeSegmentedControl: UISegmentedControl = UISegmentedControl(items: [Constant.notSelected, Constant.notFree, Constant.free])
    let dateStackView: UIStackView = UIStackView(axis: .horizontal)
    let dateHeaderLabel: UILabel = UILabel(text: Constant.dateHeaderText,
                                           font: .systemFont(ofSize: 20,
                                                             weight: .bold))
    let dateSegmentedControl: UISegmentedControl = UISegmentedControl(items: [Constant.notSelected, Constant.selected])
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: Locale.preferredLanguages[0])
        
        return datePicker
    }()
    let containerStackView: UIStackView = UIStackView(spacing: 20,
                                                      axis: .vertical)
    var currentFilter: (category: Category?, gu: Gu?, isFree: Bool?, date: Date?)
    var isDone: Bool = false
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        currentFilter = (viewModel.category, viewModel.gu, viewModel.isFree, viewModel.date)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        congifureFilters()
        addObserver()
        configureBackgroundColor()
        configureViewHierarchy()
        configureSegmentedControl()
        configureNavigationBar()
        configureCategoryButton()
        configureGuButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        cancelFilter()
    }
    
    private func congifureFilters() {
        setTexts(category: currentFilter.category,
                 gu: currentFilter.gu)
        
        guard let date = currentFilter.date else {
            datePicker.isEnabled = false
            return
        }
        
        datePicker.date = date
    }

    private func addObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setTexts(_:)),
                                               name: GlobalConstant.filterPostName,
                                               object: nil)
    }

    @objc
    private func setTexts(_ notification: Notification) {
        guard let (category, gu) = notification.object as? (Category?, Gu?) else { return }
        setTexts(category: category, gu: gu)
    }
    
    private func setTexts(category: Category?, gu: Gu?) {
        let categoryText = category?.rawValue
        let guText = gu?.rawValue
        
        categoryLabel.text = category == nil ? Constant.notSelected : categoryText
        guLabel.text = gu == nil ? Constant.notSelected : guText
    }
    
    private func configureBackgroundColor() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureViewHierarchy() {
        let safeArea = view.safeAreaLayoutGuide
        
        [categoryHeaderLabel, categoryLabel, categoryButton].forEach {
            categoryStackView.addArrangedSubview($0)
        }
        [guHeaderLabel, guLabel, guButton].forEach {
            guStackView.addArrangedSubview($0)
        }
        [feeHeaderLabel, feeSegmentedControl].forEach {
            feeStackView.addArrangedSubview($0)
        }
        [dateHeaderLabel, dateSegmentedControl, datePicker].forEach {
            dateStackView.addArrangedSubview($0)
        }
        [categoryStackView, guStackView, feeStackView, dateStackView].forEach {
            containerStackView.addArrangedSubview($0)
        }
        view.addSubview(containerStackView)
        [categoryButton, guButton].forEach {
            $0.setContentHuggingPriority(.required,
                                         for: .horizontal)
        }
        feeStackView.setCustomSpacing(40, after: feeHeaderLabel)
        dateStackView.setCustomSpacing(40, after: dateHeaderLabel)
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: safeArea.topAnchor,
                                                    constant: 20),
            containerStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,
                                                        constant: 8),
            containerStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,
                                                         constant: -8),
            containerStackView.bottomAnchor.constraint(lessThanOrEqualTo: safeArea.bottomAnchor, constant: -20),
            categoryLabel.leadingAnchor.constraint(equalTo: dateSegmentedControl.leadingAnchor),
            guLabel.leadingAnchor.constraint(equalTo: dateSegmentedControl.leadingAnchor)
        ])
    }
    
    private func configureSegmentedControl() {
        feeSegmentedControl.addTarget(self,
                                      action: #selector(selectIsFree),
                                      for: .valueChanged)
        switch currentFilter.isFree {
        case .none:
            feeSegmentedControl.selectedSegmentIndex = 0
        case .some(false):
            feeSegmentedControl.selectedSegmentIndex = 1
        case .some(true):
            feeSegmentedControl.selectedSegmentIndex = 2
        }
        dateSegmentedControl.addTarget(self,
                                       action: #selector(toggleDatePicker),
                                       for: .valueChanged)
        dateSegmentedControl.selectedSegmentIndex = currentFilter.date == nil ? 0 : 1
    }
    
    @objc
    private func selectIsFree(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            viewModel.setIsFree(nil)
        case 1:
            viewModel.setIsFree(false)
        default:
            viewModel.setIsFree(true)
        }
    }

    @objc
    private func toggleDatePicker(_ segmentedControl: UISegmentedControl) {
        datePicker.isEnabled = segmentedControl.selectedSegmentIndex != 0
    }
    
    private func configureNavigationBar() {
        navigationItem.title = Constant.navigationTitle
        navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .cancel,
                                                           primaryAction: makeCancelAction())
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .done,
                                                            primaryAction: makeDoneAction())
    }
    
    private func makeCancelAction() -> UIAction {
        let action = UIAction() { [weak self] _ in
            self?.dismiss(animated: true)
        }
        
        return action
    }
    
    private func makeDoneAction() -> UIAction {
        let action = UIAction() { [weak self] _ in
            if self?.datePicker.isEnabled == true {
                self?.viewModel.setDate(self?.datePicker.date)
            } else {
                self?.viewModel.setDate(nil)
            }
            self?.isDone = true
            self?.dismiss(animated: true)
        }
        
        return action
    }
    
    private func cancelFilter() {
        guard isDone == false else { return }
        
        viewModel.setCategory(currentFilter.category)
        viewModel.setGu(currentFilter.gu)
        viewModel.setIsFree(currentFilter.isFree)
    }
    
    private func configureCategoryButton() {
        let notSelectedAction = UIAction(title: Constant.notSelected) { [weak self] _ in
            self?.viewModel.setCategory(nil)
        }
        var actions = [notSelectedAction]
        
        Category.allCases.forEach { category in
            let action = UIAction(title: category.rawValue) { [weak self] _ in
                self?.viewModel.setCategory(category)
            }
            
            actions.append(action)
        }
        
        categoryButton.menu = UIMenu(children: actions)
        categoryButton.showsMenuAsPrimaryAction = true
    }
    
    private func configureGuButton() {
        let notSelectedAction = UIAction(title: Constant.notSelected) { [weak self] _ in
            self?.viewModel.setGu(nil)
        }
        var actions = [notSelectedAction]
        
        Gu.allCases.forEach { gu in
            let action = UIAction(title: gu.rawValue) { [weak self] _ in
                self?.viewModel.setGu(gu)
            }
            
            actions.append(action)
        }
        
        guButton.menu = UIMenu(children: actions)
        guButton.showsMenuAsPrimaryAction = true
    }
}

extension FilterViewController {
    
    enum Constant {
        
        static let categoryHeaderText: String = "분류"
        static let guHeaderText: String = "구"
        static let feeHeaderText: String = "요금"
        static let dateHeaderText: String = "날짜"
        static let notFree: String = "유료"
        static let free: String = "무료"
        static let notSelected: String = "선택 안 함"
        static let selected: String = "선택"
        static let buttonImageName: String = "chevron.down"
        static let navigationTitle: String = "필터"
    }
}
