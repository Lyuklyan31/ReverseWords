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
    private let textFieldLine = UIView()
    private let reversedTextScrollView = UIScrollView()
    private let reversedTextLabel = UILabel()
    private let actionButton = UIButton()
    
    private var currentState: ScreenState = .clear {
        didSet {
            updateButtonAppearance()
        }
    }
    
    private let reverseWordsService = ReverseWordsService()
    
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
        setupTextFieldLine()
        setupReversedTextScrollView()
        setupReversedTextLabel()
        setupActionButton()
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
        reversTextField.accessibilityIdentifier = "textFieldIdentifier"
        
        view.addSubview(reversTextField)
        
        reversTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(descriptionLabel.snp.bottom).offset(59)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    // Setup LineForTextField
    private func setupTextFieldLine() {
        textFieldLine.backgroundColor = UIColor(.ownColorGray.opacity(0.3))
        
        view.addSubview(textFieldLine)
        
        textFieldLine.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(reversTextField.snp.bottom).offset(18)
        }
    }
    
    // Setup ScrollViewForTextReversed and ReversedTextLabel
    private func setupReversedTextScrollView() {
        view.addSubview(reversedTextScrollView)
        
        reversedTextScrollView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(textFieldLine.snp.bottom).offset(24)
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
    
    // Setup ReverseAndClearButton
    private func setupActionButton() {
        actionButton.layer.cornerRadius = 14
        actionButton.accessibilityIdentifier = "actionButtonIdentifier"
        
        view.addSubview(actionButton)
        
        actionButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(13)
            make.trailing.equalToSuperview().offset(-13)
            make.bottom.equalToSuperview().offset(-66)
            make.height.equalTo(60)
        }
        
        actionButton.addTarget(self, action: #selector(buttonReverse(_:)), for: .touchUpInside)
        updateButtonAppearance()
    }
    
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
    
    // Action method for the reverse/clear button
    @objc private func buttonReverse(_ sender: Any) {
        guard let text = reversTextField.text, !text.isEmpty else {
            currentState = .clear
            return
        }
        
        if case .reversedText(let existingText) = currentState, existingText == text {
            currentState = .clear
            reversTextField.text = ""
            reversedTextLabel.text = ""
        } else {
            currentState = .reversedText(textToReverse: text)
            reversedTextLabel.text = reverseWordsInText(text)
        }
    }
    
    // Update button appearance based on the current state
    private func updateButtonAppearance() {
        switch currentState {
        case .clear:
            actionButton.setTitle("Reverse", for: .normal)
            actionButton.backgroundColor = UIColor(.ownColorBlue.opacity(0.6))
            actionButton.isEnabled = false
        case .enteredText:
            actionButton.setTitle("Reverse", for: .normal)
            actionButton.backgroundColor = UIColor.ownColorBlue
            actionButton.isEnabled = true
        case .reversedText:
            actionButton.setTitle("Clear", for: .normal)
            actionButton.backgroundColor = UIColor.ownColorBlue
            actionButton.isEnabled = true
        }
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
    
    // Method called when editing begins
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldLine.backgroundColor = UIColor.ownColorBlue
    }
    
    // Method called when editing ends
    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldLine.backgroundColor = textField.text?.isEmpty ?? true
            ? UIColor(.ownColorDarkGray.opacity(0.3))
            : UIColor.ownColorBlue
    }
    
    // Method to handle return key press
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
