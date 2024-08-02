//
//  ViewController.swift
//  reverseWords2
//
//  Created by admin on 02.08.2024.
//

import UIKit
import SnapKit

enum ScreenState: Equatable {
    case clear
    case enteredText
    case reversedText(textToReverse: String)
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
    
    private var currentState: ScreenState = .clear {
        didSet {
            
        }
    }
    
    private let reverseWordsService = ReverseWordsService()
    var ignoreText = ""
    
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
        
        if configurationSegment.selectedSegmentIndex == 0 {
            setupDefaultLabel()
        } else {
            setupIgnoreTextField()
        }
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
            make.leading.equalTo(view).offset(16)
            make.trailing.equalTo(view).offset(-16)
        }
    }
    
    // Setup TitleDescriptionLabel
    private func setupDescriptionLabel() {
        descriptionLabel.text = "This application will reverse your words. Please type text below"
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = UIColor(.ownColorDarkGray.opacity(0.3))
        descriptionLabel.font = UIFont.boldSystemFont(ofSize: 17)
        descriptionLabel.numberOfLines = 2
        descriptionLabel.lineBreakMode = .byWordWrapping
        
        view.addSubview(descriptionLabel)
        
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    // Setup TextFieldForReverse
    private func setupReversTextField() {
        reversTextField.placeholder = "Text to reverse"
        reversTextField.borderStyle = .roundedRect
        reversTextField.accessibilityIdentifier = "textFieldIdentifier"
        
        
        view.addSubview(reversTextField)
        
        reversTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(descriptionLabel.snp.bottom).offset(59)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    private func setupConfigurationSegment() {
        configurationSegment.insertSegment(withTitle: "Default", at: 0, animated: true)
        configurationSegment.insertSegment(withTitle: "Custom", at: 1, animated: true)
        configurationSegment.selectedSegmentIndex = 0
        
        view.addSubview(configurationSegment)
        configurationSegment.snp.makeConstraints { make in
            make.top.equalTo(reversTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    private func setupDefaultLabel() {
        defaultTextLabel.text = "All characters exepct alphabetic symbols"
        defaultTextLabel.font = UIFont.boldSystemFont(ofSize: 15)
        defaultTextLabel.textAlignment = .center
        
        view.addSubview(defaultTextLabel)
        defaultTextLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(configurationSegment.snp.bottom).offset(20)
        }
    }
    
    private func setupIgnoreTextField() {
        ignoreTextField.placeholder = "Text to ignore"
        ignoreTextField.borderStyle = .roundedRect
        
        view.addSubview(ignoreTextField)
        ignoreTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(configurationSegment.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    private func setupResultLabel() {
        resultLabel.text = "Result:"
        resultLabel.textAlignment = .center
        
        view.addSubview(resultLabel)
        resultLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            if configurationSegment.selectedSegmentIndex == 0 {
                make.top.equalTo(defaultTextLabel.snp.bottom).offset(30)
            } else {
                make.top.equalTo(ignoreTextField.snp.bottom).offset(30)
            }
        }
    }
    
    // Setup ScrollViewForTextReversed and ReversedTextLabel
    private func setupReversedTextScrollView() {
        view.addSubview(reversedTextScrollView)
        
        reversedTextScrollView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(resultLabel.snp.bottom).offset(24)
            make.height.equalTo(30)
        }
    }
    
    // Setup ReversedTextLabel
    private func setupReversedTextLabel() {
        reversedTextLabel.textColor = UIColor.ownColorBlue
        reversedTextLabel.font = UIFont.systemFont(ofSize: 24)
        reversedTextLabel.accessibilityIdentifier = "reverseTextIdentifier"
        
        reversedTextScrollView.addSubview(reversedTextLabel)
        
        reversedTextLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.bottom.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        reversedTextLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        reversedTextLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    
//    func updateText(with text: String? = nil) {
//        let text = text ?? reversTextField.text ?? ""
//        let ignoreWords = Set(ignoreText.components(separatedBy: " ").filter { !$0.isEmpty })
//        
//        let isCustomMode = segmentControl.selectedSegmentIndex == 1
//        let shouldReverseDigits = isCustomMode
//        let shouldReverseSpecialCharacters = isCustomMode
//
//        reverseText.text = reverseWordsService.reverseWords(
//            in: text,
//            ignoring: ignoreWords,
//            reverseDigits: shouldReverseDigits,
//            reverseSpecialCharacters: shouldReverseSpecialCharacters,
//            isCustomMode: isCustomMode
//        )
//        updateScrollViewContentSize()
//    }
    
    
    // Setup gesture recognizers
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // Setup text field delegates
    private func setupDelegates() {
        reversTextField.delegate = self
    }
    
    // Dismiss keyboard when tapping outside of the text field
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // Reverse the text entered by the user
    private func reverseWordsInText(_ text: String) -> String {
        return text.split(separator: " ").map { String($0.reversed()) }.joined(separator: " ")
    }
}

// Extension to handle text field delegate methods
extension MainViewController: UITextFieldDelegate {
    // Method to handle text changes
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            currentState = updatedText.isEmpty ? .clear : .enteredText
            reversedTextLabel.text = updatedText.isEmpty ? "" : reversedTextLabel.text
        }
        return true
    }
 
    // Method to handle return key press
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
