//
//  ViewController.swift
//  reverseWords2
//
//  Created by admin on 02.08.2024.
//

import UIKit
import SnapKit

enum ScreenState: Equatable {
    case defaultSegment
    case customSegment
}

class MainViewController: UIViewController {
    
    // UI Elements
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    private let reversTextField = UITextField()
    private let configurationSegment = UISegmentedControl()
    private let defaultTextLabel = UILabel()
    private let ignoreTextField = UITextField()
    private let resultLabel = UILabel()
    
    private let reversedTextScrollView = UIScrollView()
    private let reversedTextLabel = UILabel()
    
    private var currentState: ScreenState = .defaultSegment {
        didSet {
            updateSegmentMode()
        }
    }
    
    private let reverseWordsService = ReverseWordsService()
    private var ignoreText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultConfiguration()
    }
    
    // Initial configuration
    private func defaultConfiguration() {
        setupNavigationBar()
        setupUI()
        setupGestures()
        setupDelegates()
        updateSegmentMode()
    }
    
    // Setup navigation bar appearance
    private func setupNavigationBar() {
        if let navigationBar = self.navigationController?.navigationBar {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
        }
        view.backgroundColor = .systemBackground
        title = "Reverse Words"
    }
    
    // Setup UI elements and constraints
    private func setupUI() {
        setupTitleLabel()
        setupDescriptionLabel()
        setupReversTextField()
        setupConfigurationSegment()
        setupDefaultLabel()
        setupIgnoreTextField()
        setupResultLabel()
        setupReversedTextScrollView()
        setupReversedTextLabel()
    }
    
    // Setup TitleLabel
    private func setupTitleLabel() {
        titleLabel.text = "Reverse Words"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 34)
        titleLabel.textAlignment = .center
        
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(64)
            make.leading.trailing.equalTo(view).inset(16)
        }
    }
    
    // Setup DescriptionLabel
    private func setupDescriptionLabel() {
        descriptionLabel.text = "This application will reverse your words. Please type text below"
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = UIColor(.ownColorDarkGray.opacity(0.6))
        descriptionLabel.font = UIFont.systemFont(ofSize: 17)
        descriptionLabel.numberOfLines = 2
        descriptionLabel.lineBreakMode = .byWordWrapping
        
        view.addSubview(descriptionLabel)
        
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    // Setup TextField for reversing
    private func setupReversTextField() {
        reversTextField.placeholder = "Text to reverse"
        reversTextField.borderStyle = .roundedRect
        reversTextField.accessibilityIdentifier = "textFieldIdentifier"
        
        view.addSubview(reversTextField)
        
        reversTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(descriptionLabel.snp.bottom).offset(59)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    // Setup configuration segment
    private func setupConfigurationSegment() {
        configurationSegment.insertSegment(withTitle: "Default", at: 0, animated: true)
        configurationSegment.insertSegment(withTitle: "Custom", at: 1, animated: true)
        configurationSegment.selectedSegmentIndex = 0
        configurationSegment.accessibilityIdentifier = "segmentControl"
        configurationSegment.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        
        view.addSubview(configurationSegment)
        configurationSegment.snp.makeConstraints { make in
            make.top.equalTo(reversTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    @objc private func segmentChanged() {
        currentState = configurationSegment.selectedSegmentIndex == 0 ? .defaultSegment : .customSegment
    }
    
    // Setup DefaultLabel
    private func setupDefaultLabel() {
        defaultTextLabel.text = "All characters except alphabetic symbols"
        defaultTextLabel.font = UIFont.boldSystemFont(ofSize: 15)
        defaultTextLabel.textAlignment = .center
        defaultTextLabel.accessibilityIdentifier = "defaultTextLabel"
        
        view.addSubview(defaultTextLabel)
        defaultTextLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(configurationSegment.snp.bottom).offset(20)
        }
    }
    
    // Setup IgnoreTextField
    private func setupIgnoreTextField() {
        ignoreTextField.placeholder = "Text to ignore"
        ignoreTextField.borderStyle = .roundedRect
        ignoreTextField.accessibilityIdentifier = "customTextField"
        
        ignoreTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        view.addSubview(ignoreTextField)
        ignoreTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(configurationSegment.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    // Setup ResultLabel
    private func setupResultLabel() {
        resultLabel.text = "Result:"
        resultLabel.textAlignment = .center
        resultLabel.accessibilityIdentifier = "reverseTextIdentifier"
        
        view.addSubview(resultLabel)
        resultLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(configurationSegment.snp.bottom).offset(70)
        }
    }
    
    // Setup ScrollView for reversed text and ReversedTextLabel
    private func setupReversedTextScrollView() {
        view.addSubview(reversedTextScrollView)
        
        reversedTextScrollView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(resultLabel.snp.bottom).offset(24)
            make.height.equalTo(30)
        }
    }
    
    // Setup ReversedTextLabel
    private func setupReversedTextLabel() {
        reversedTextLabel.font = UIFont.systemFont(ofSize: 24)
        reversedTextLabel.accessibilityIdentifier = "reverseText"
        
        reversedTextScrollView.addSubview(reversedTextLabel)
        
        reversedTextLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.height.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        reversedTextLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        reversedTextLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    
    // Update text with considering ignored words and current settings
    func updateText(with text: String? = nil) {
        let text = text ?? reversTextField.text ?? ""
        let ignoreWords = Set(ignoreText.components(separatedBy: " ").filter { !$0.isEmpty })
        
        let isCustomMode = configurationSegment.selectedSegmentIndex == 1
        let shouldReverseDigits = isCustomMode
        let shouldReverseSpecialCharacters = isCustomMode

        reversedTextLabel.text = reverseWordsService.reverseWords(
            in: text,
            ignoring: ignoreWords,
            reverseDigits: shouldReverseDigits,
            reverseSpecialCharacters: shouldReverseSpecialCharacters,
            isCustomMode: isCustomMode,
            ignoreCharacters: Set(ignoreText)
        )
    }
    
    // Update UI for the selected segment
    private func updateSegmentMode() {
        switch currentState {
        case .defaultSegment:
            dismissKeyboard()
            updateText()
            defaultTextLabel.isHidden = false
            ignoreTextField.isHidden = true
        case .customSegment:
            dismissKeyboard()
            updateText()
            defaultTextLabel.isHidden = true
            ignoreTextField.isHidden = false
        }
    }
    
    // Update ignored text field
    func didUpdateIgnoreTextField(_ text: String) {
        ignoreText = text.lowercased()
        updateText()
    }
    
    // Setup gesture recognizers
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // Setup text field delegates
    private func setupDelegates() {
        reversTextField.delegate = self
        ignoreTextField.delegate = self
    }
    
    // Handler for text field change
    @objc func textFieldDidChange(_ textField: UITextField) {
        didUpdateIgnoreTextField(textField.text ?? "")
    }
    
    // Dismiss keyboard when tapping outside the text field
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // Reverse the text entered by the user
    private func reverseWordsInText(_ text: String) -> String {
        return text.split(separator: " ").map { String($0.reversed()) }.joined(separator: " ")
    }
}

// Extension for handling text field delegate methods
extension MainViewController: UITextFieldDelegate {
    // Method for handling text changes
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        updateText(with: updatedText)
        return true
    }
    
    // Method for handling return key press
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
