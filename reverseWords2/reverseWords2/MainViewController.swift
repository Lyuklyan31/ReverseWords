//
//  ViewController.swift
//  reverseWords2
//
//  Created by admin on 02.08.2024.
//

import UIKit // Імпортую фреймворк UIKit для доступу до всіх його класів і методів крім тих що позначені "private і fileprivate"
import SnapKit // Імпортую SnapKit для зручнішого та зрозумілішого написання констрейнтів

enum ScreenState { // створюю енам з 2 кейсами для відображення або дефолт тексту або тексфілда для ігнорування
    case defaultSegment // у цьому кейсі буде дефолт текст
    case customSegment // у цьому кейсі буде ігнор текстфілд
}

class MainViewController: UIViewController { // оголошую клас MainViewController та наслідуюсь у класу UIViewController та отрмую всі класи методи і проперті які мають відкритий доступ тобто всі окрім private i fileprivate також маю можливість оверрайдити(перевизначити можливості базовго класу) сторед проперті базового класу оверайднути не можна
    
    //MARK: UI Elements
    
    private let titleLabel = UILabel() // створюю екземпляр класу UILabel() та створюю лейбл для заголока
    private let descriptionLabel = UILabel() // створюю екземпляр класу UILabel() та створюю опис про що ця апка
    
    private let reversTextField = UITextField() // створюю екземпляр класу UITextField() та створюю текстове поле для уводу того, що потрібно реверсити
    private let configurationSegment = UISegmentedControl() // створюю екземпляр класу UISegmentedControl() для реалізації вибору між станами енам
    private let defaultTextLabel = UILabel() // напис який буде в опції дефолт екземпляр класу UILabel()
    private let ignoreTextField = UITextField() // текстове поле для ігнорування екземпляр класу UITextField()
    private let resultLabel = UILabel() // лейбл для напису "Result" екземпляр класу UILabel()
    private let reversedTextLabel = UILabel() // текст який буде реверснутий екземпляр класу UILabel()
    private let reversedTextScrollView = UIScrollView() // екземпляр класу UIScrollView() для прокручування сторінки в тому разі якшо контент ширший за дефолт екран
    
    private var currentState: ScreenState = .defaultSegment { // оголошую обчислювальну змінну currentState з типом енама "ScreenState" і по дефолту має кейс .defaultSegment
        didSet { // проперті обсервер стежить за зміною currentState і спрацьовує після зміни кейсу
            updateSegmentMode() // метод який мніяє/оновлює юай
        }
    }
    
    private let reverseWordsService = ReverseWordsService() // створюю екземпляр класу ReverseWordsService() для реалізації логіку правильного реверсу
    private var ignoreText = "" // змінна для тексту який буде уводитись у текстфілд ігнорі для подальшої роботи з нею у методах
    
        //Усе що позначенн private означає що до цих проперті констант методів... буде доступ тільки у межах цього класу
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultConfiguration() // виклик функції з всією логікою та UI
    }
    
    // Initial configuration
    private func defaultConfiguration() {
        setupNavigationBar() // встановлення навігейшин бара
        setupUI() // встановлення UI та констрейнтів
        setupGestures() // встановвлення закриття клавіатури по тапу будь де на екрані
        setupDelegates() // встановлення делегатів
        updateSegmentMode() // встановлення логіки сегмента
    }
    
    // Setup navigation bar appearance
    private func setupNavigationBar() { // оголошення приватної функції для встановленна навігейшин бара
        if let navigationBar = self.navigationController?.navigationBar { // перевіряється чи мій MainViewController обгорнутий у файлі SceneDelegate у navigation controller і чи може мати навігейшин бра тобто ось цей рядок з SceneDelegate
            ///  window?.rootViewController = UINavigationController(rootViewController: MainViewController())
            ///  тобто віндов я розумію як екран який ми бачимо і я присвоюю йому MainViewController як кореневий вʼю контроллер і обгортаю його одразу у навігейшин контроллер
            let appearance = UINavigationBarAppearance() // тут я створюю екземпляр класу вигляду вʼю контроллера і отримую доступ до всіх його настройок вигляду як ти називав "з коробки"
            appearance.configureWithDefaultBackground() // підлаштовує колір таб бару під колір беграунда екрана
            navigationBar.standardAppearance = appearance // вигляд таб бару без скролу
            navigationBar.scrollEdgeAppearance = appearance // вигляд таб бару під час скролу
        }
        view.backgroundColor = .systemBackground // задаю колір бекграунда .systemBackground який міняється в залежності від теми на пристрої
        title = "Reverse Words" // заголовок таб бару
    }
    
    // Setup UI elements and constraints
    private func setupUI() { // встановлення UI елемнтів за допомогою приватного метода у якому виклик інших методів
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
    private func setupTitleLabel() { // метод для встановлення тайтла заголовка
        titleLabel.text = "Reverse Words" // текст лейбла
        titleLabel.font = UIFont.boldSystemFont(ofSize: 34) // розмір та стиль тексту
        titleLabel.textAlignment = .center // розміщення на екрані
        
        view.addSubview(titleLabel) // додаю до view тобто view тут MainViewController сабвʼю titleLabel
        
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
        reversTextField.accessibilityIdentifier = "textField"
        
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
            make.top.equalTo(configurationSegment.snp.bottom).offset(24)
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
            make.top.equalTo(configurationSegment.snp.bottom).offset(25)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    // Setup ResultLabel
    private func setupResultLabel() {
        resultLabel.text = "Result:"
        resultLabel.textAlignment = .center
        resultLabel.font = UIFont.systemFont(ofSize: 18)
        
        view.addSubview(resultLabel)
        resultLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(configurationSegment.snp.bottom).offset(85)
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
