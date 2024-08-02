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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        
        view.addSubview(actionButton)
        
        actionButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(13)
            make.trailing.equalToSuperview().offset(-13)
            make.bottom.equalToSuperview().offset(-66)
            make.height.equalTo(60)
        }
    }
}

