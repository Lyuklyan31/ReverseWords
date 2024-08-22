//
//  ViewController.swift
//  reverseWords2
//
//  Created by admin on 02.08.2024.
//

import UIKit // Імпортую фреймворк UIKit для доступу до всіх його класів і методів крім тих що позначені "private і fileprivate"
import SnapKit // Імпортую SnapKit для зручнішого та зрозумілішого написання констрейнтів

enum ScreenState: Equatable { // створюю енам з 2 кейсами для відображення або дефолт тексту або тексфілда для ігнорування
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
        // override перевизначає метод viewDidLoad з базового класу UIViewController
        // func viewDidLoad() Метод, що автоматично викликається після завантаження перегляду вʼю в пам'ять
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
        setupResultLabel()
        setupReversedTextScrollView()
        setupReversedTextLabel()
    }
    
    // Setup TitleLabel
    private func setupTitleLabel() { // метод для встановлення тайтла заголовка
        titleLabel.text = "Reverse Words" // текст лейбла
        titleLabel.font = UIFont.boldSystemFont(ofSize: 34) // розмір та стиль тексту
        titleLabel.textAlignment = .center // вирівнюю текст горизонтально по центру UILabel
        
        view.addSubview(titleLabel) // додаю до супервʼю titleLabel
        
//        titleLabel.snp.makeConstraints { make in // викликаю клоужер для налаштування автолейоту
//            // titleLabel це вʼю
//            // snp це екстеншин до UIView що дає доступ до налаштування автолейота
//            make.centerX.equalToSuperview() // розміщую середину titleLabel по Х у середині супер вʼю по Х
//            make.top.equalTo(view.safeAreaLayoutGuide).offset(64) // роблю констрейнт між верхом titleLabel та безпечною зоною супервʼю 64
//            make.leading.trailing.equalToSuperview().inset(16) // за допомогою inset()одночаснно задаю констрейнти - та + тобто зліва та справа 16
//        }
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20)
        ])
        
        
    }
   
    // Setup DescriptionLabel
    private func setupDescriptionLabel() { // метод для встановлення тексту опису що робить програма який знаходиться під заголовком
        descriptionLabel.text = "This application will reverse your words. Please type text below" // присвоюю текст лейблу
        descriptionLabel.textAlignment = .center // розміщуюю текст в центрі екрану
        descriptionLabel.textColor = UIColor(.ownColorDarkGray.opacity(0.6)) // задаю колір
        descriptionLabel.font = UIFont.systemFont(ofSize: 17) // задаю розмір шрифту
        descriptionLabel.numberOfLines = 2 // задаю максимально можливу кількість рядків лейбла
        
        view.addSubview(descriptionLabel) // додаю до супервʼю descriptionLabel
        
        descriptionLabel.snp.makeConstraints { make in // викликаю клоужер для налаштування автолейоту
            make.centerX.equalToSuperview() // розміщую середину descriptionLabel по Х у середині супер вʼю по Х
            make.top.equalTo(titleLabel.snp.bottom).offset(16) // роблю констрейнт між верхом descriptionLabel та між низом titleLabel 16
            make.leading.trailing.equalToSuperview().inset(16) // за допомогою inset()одночаснно задаю констрейнти - та + тобто зліва та справа 16
        }
    }
    
    // Setup TextField for reversing
    private func setupReversTextField() { // приватний метод встановлення текстфілда
        reversTextField.placeholder = "Text to reverse" // текст який відображається коли текстфілд пустий
        reversTextField.borderStyle = .roundedRect // задаю рамку обведення
        reversTextField.accessibilityIdentifier = "textField" // створюю індифікатор для Unit тестів
        
        view.addSubview(reversTextField) // додаю до супервʼю reversTextField
        
        reversTextField.snp.makeConstraints { make in // клоужер встановлення автолейота
            make.centerX.equalToSuperview() // розміщую центр reversTextField в центрі супервʼю
            make.top.equalTo(descriptionLabel.snp.bottom).offset(59) // відступ між верхньою стороною reversTextField та нижньою стороною descriptionLabel
            make.leading.trailing.equalToSuperview().inset(16) // за допомогою inset()одночаснно задаю констрейнти - та + тобто зліва та справа 16
        }
    }
    
    // Setup configuration segment
    private func setupConfigurationSegment() { // приватний метод для встановлення сегменту
        configurationSegment.insertSegment(withTitle: "Default", at: 0, animated: true) // Створюю опцію сегмента даю назву ідекс і додаю анімацію
        configurationSegment.insertSegment(withTitle: "Custom", at: 1, animated: true) // Створюю опцію сегмента даю назву ідекс і додаю анімацію
        configurationSegment.selectedSegmentIndex = 0 // задаю опція по замовчуванню
        configurationSegment.accessibilityIdentifier = "segmentControl" // індефікатор для Unit тестів
        configurationSegment.addTarget(self, action: #selector(segmentChanged), for: .valueChanged) // додаю обробник подій
        // self це обʼєкт що буде обробляти подію тобто тут це поточний клас MainViewController
        // action - селектор що вказує на метод segmentChanged, який буде викликаний при зміні вибору сегмента
        // for: .valueChanged  тип події яка спрацьовує коли вибір сегмента зміниться
        
        view.addSubview(configurationSegment) // додаю на супервʼю configurationSegment
        configurationSegment.snp.makeConstraints { make in // створюю обмеження
            make.top.equalTo(reversTextField.snp.bottom).offset(20) // верхня сторона сегмента та нижня сторона текстфілда будуть мати відтсуп 20
            make.leading.trailing.equalToSuperview().inset(16) // за допомогою inset()одночаснно задаю констрейнти - та + тобто зліва та справа 16
        }
    }
    
    @objc private func segmentChanged() { // ця функція позначенна @objc для того щоб її можна було використатии у селекторі обробника подій
        currentState = configurationSegment.selectedSegmentIndex == 0 ? .defaultSegment : .customSegment
        // міняє поточний стан currentState в залежності від вибраної опції
        // якщо вибраний selectedSegmentIndex рівний 0 то воно покаже юай який у кейсі .defaultSegment
        // якщо вибраний selectedSegmentIndex рівний 0 то воно покаже юай який у кейсі .customSegment
    }
    
    // Setup DefaultLabel
    private func setupDefaultLabel() { // приватний метод для встановлення лейбла який буде у стані дефолт
        defaultTextLabel.text = "All characters except alphabetic symbols" // встановлююю текст для лейбла
        defaultTextLabel.font = UIFont.boldSystemFont(ofSize: 15) // ромір шрифту лейбла
        defaultTextLabel.textAlignment = .center // розміщення тексту по середині
        defaultTextLabel.accessibilityIdentifier = "defaultTextLabel" // індифікатор для юніт тестів
        
        view.addSubview(defaultTextLabel) // додаю до супер вʼю дефолт лейбл
        defaultTextLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()  // розміщую середину по це центру Х
            make.top.equalTo(configurationSegment.snp.bottom).offset(24) // роблю констрейнт між веерхом defaultTextLabel та низом configurationSegment
        }
    }
    
    // Setup IgnoreTextField
    private func setupIgnoreTextField() { // приватний метод для встановлення текстфілда який буде у стані дефолт
        ignoreTextField.placeholder = "Text to ignore" // плейсхолдер
        ignoreTextField.borderStyle = .roundedRect // обводка таж шо я писав у горі
        ignoreTextField.accessibilityIdentifier = "customTextField" // індифікатор для юніт теістів
        
        ignoreTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        // додаю обробник подій для текстового поля
        // action: #selector(textFieldDidChange(_:)) метод який буде викликаний після виклку події editingChanged
        //.editingChanged тип події яка спрацьовує при зміні тексту в ignoreTextField подія editingChanged викликається кожного разу коли текст у текстовому полі змінюється тобто при кожному введенні символу та видаленні символу
        
        view.addSubview(ignoreTextField)  // додаю до вʼю контроллера вʼюшку ігнор текстфілда
        ignoreTextField.snp.makeConstraints { make in   // клоужер для створення обмежень
            make.centerX.equalToSuperview()   // розміщую по це центру Х
            make.top.equalTo(configurationSegment.snp.bottom).offset(25) // верхня сторона ignoreTextField буде мати відступ 20 від нижньої сторони configurationSegment
            make.leading.trailing.equalToSuperview().inset(16) // за допомогою inset()одночаснно задаю констрейнти - та + тобто зліва та справа 16
        }
    }
    
    // Setup ResultLabel
    private func setupResultLabel() { // приватний метод для лейбл результата
        resultLabel.text = "Result:" // текст лейбла
        resultLabel.textAlignment = .center // розміщення тексту у рядку
        resultLabel.font = UIFont.systemFont(ofSize: 18) // розмір та шрифт лейбла
        
        view.addSubview(resultLabel) // додаю на вʼю лейбл
        resultLabel.snp.makeConstraints { make in // клоужер для створення констрейнтів
            make.centerX.equalTo(view.snp.centerX) // розміщую середину resultLabel по центру Х на супервʼю по центру по Х
            make.top.equalTo(configurationSegment.snp.bottom).offset(85) // роблю відступ верехнього краю resultLabel до низу configurationSegment з відступом 85
        }
    }
    
    // Setup ScrollView for reversed text and ReversedTextLabel
    private func setupReversedTextScrollView() {  // приватний метод для встановлення скролу
        
        view.addSubview(reversedTextScrollView) // додаю скрол на вʼю
        reversedTextScrollView.snp.makeConstraints { make in // клоужер для встановлення констрейнтів
            make.leading.trailing.equalToSuperview().inset(16) // відступ зліва справа 16
            make.top.equalTo(resultLabel.snp.bottom).offset(24) // відступ верхнього краю reversedTextScrollView до нижнього краю resultLabel
            make.height.equalTo(30) // задаю висоту reversedTextScrollView
        }
    }
    
    // Setup ReversedTextLabel
    private func setupReversedTextLabel() { // метод для встановлення реверснутого тексту у скролвʼю
        reversedTextLabel.font = UIFont.systemFont(ofSize: 24) // розмір шрифту
        reversedTextLabel.accessibilityIdentifier = "reverseText" // індифікатор для юніт тестів
        
        reversedTextScrollView.addSubview(reversedTextLabel) // додаю у reversedTextScrollView лейбл reversedTextLabel
        
        reversedTextLabel.snp.makeConstraints { make in // клоужер для обмежень
            make.bottom.equalTo(reversedTextScrollView.snp.bottom) // роблю нижній край reversedTextLabel рівний нижньому краю reversedTextScrollView
            make.top.equalTo(reversedTextScrollView.snp.top) // роблю верхній край reversedTextLabel рівний верхньому краю reversedTextScrollView
            make.height.equalToSuperview() // задаю висоту рівну супервʼю тобто reversedTextScrollView
            make.leading.trailing.equalToSuperview() // задаю відступи злів та справа рівні reversedTextScrollView
        }
        reversedTextLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        // setContentHuggingPriority метод що вказує на пріорітет обнімання(тобто розширення у разі збільшення тексту у лейблі)
        //.defaultLow це значення пріорітету обнімання що означає що елемент має низький пріорітет і він не надто буде наполягати на збереження власного розміру
        // .horizontal означає що це буде відбуватись тільки горизонтально тобто його ширина залежить від лейбла
        reversedTextLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        //setContentCompressionResistancePriority метод, який задає пріоритет стискання для даного виду компонента
        // .defaultHigh значення пріоритету стиснення яке означає що елемент має високий пріоритет у стисненні reversedTextLabel буде наполягати на тому щоб зберігати свою ширину навіть якщо є обмеження простору
        // for: .horizontal це вказує що налаштування застосовуються у горизонтальному напрямку
    }
    
    // Update text with considering ignored words and current settings
    func updateText(with text: String? = nil) { // функція updateText має один параметр text який є опшиналом це означає що параметр може бути або String, або nil
        let text = text ?? reversTextField.text ?? "" // цей рядок ініціалізує константу text перевіряє чи парпметр text не є nil якшо nil перевіряє reversTextField.text і якщо і цей параметр ніл використовую ""
        let ignoreWords = Set(ignoreText.components(separatedBy: " ").filter { !$0.isEmpty })
        // Створюється набір ignoreWords. ignoreText розбивається на масив слів за допомогою компонента що відокремлює пробіли (" ")
        // .filter { !$0.isEmpty } видаляє пусті рядки щоб набір містив тільки непорожні слова.
        // Set(...) перетворює масив слів на множину що виключає повторювані слова
        
        let isCustomMode = configurationSegment.selectedSegmentIndex == 1 // перевіряє чи вибрана опція рівна індексу 1 якщо так isCustomMode стає true якшо ні false
        let shouldReverseDigits = isCustomMode // створюю булеву змінну shouldReverseDigits яка дорівнює значеню isCustomMode
        let shouldReverseSpecialCharacters = isCustomMode // створюю булеву змінну shouldReverseSpecialCharacters яка дорівнює значеню isCustomMode
        
        reversedTextLabel.text = reverseWordsService.reverseWords( // викликаю метод сервісу reverseWordsService який створив для логіки реверсу
            in: text, // передаю у нього текст
            ignoring: ignoreWords, // слова ігнорування
            reverseDigits: shouldReverseDigits, // булеву змінну чи повинні реверситись літери
            reverseSpecialCharacters: shouldReverseSpecialCharacters, // булеву змінну чи потрібно реверсити спец символи
            isCustomMode: isCustomMode, // чи є це кастом опція сегмента
            ignoreCharacters: Set(ignoreText) // і передаю набір символів для ігнорування
        )
    }
    
    // Update UI for the selected segment
    private func updateSegmentMode() { // приватний метод для встановлення поточного стану енам
        switch currentState {
            // switch перевіряє значення змінної currentState
            //визначає, який блок коду виконати, залежно від значення currentState.
        case .defaultSegment: // switch перевіряє чи currentState є .defaultSegment якщо так виконує ці умови що у кейсі
            dismissKeyboard() // закрити клавіатуру
            setupDefaultLabel() // встановити напис який створенний для дефолт стану
            updateText() // оновлює текст під певні умови
            defaultTextLabel.isHidden = false // показує лейбл
            ignoreTextField.isHidden = true // приховує текстфілд
        case .customSegment:  // switch перевіряє чи currentState є .customSegment якщо так виконує ці умови що у кейсі
            dismissKeyboard() // закрити клавіатуру
            setupIgnoreTextField()// встановити текстфілд який створенний для ігнорування літер
            updateText() // оновлює текст під певні умови
            defaultTextLabel.isHidden = true // приховує лейбл
            ignoreTextField.isHidden = false // показує текстфілд
        }
    }
    
    // Update ignored text field
    // метод для однакової робити як з великими так і з малими літерами
    func didUpdateIgnoreTextField(_ text: String) {
        ignoreText = text.lowercased() // перевтворює всі літери що у текстфілд ігнорі на малі
        updateText() // викликаю метод для оновлення тексту
    }
    
    // Setup gesture recognizers
    private func setupGestures() { // приватний метод для налаштування жестів наприклад для обробки тапів і закриття клавіатури
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        // метод UITapGestureRecognizer для розпізнавання тапів на перегляді
        // target: self вказує, що обробник жесту є поточний об'єкт контролер перегляду)
        // action: #selector(dismissKeyboard) метод який буде викликаний при розпізнаванні жесту тут це dismissKeyboard
        view.addGestureRecognizer(tapGesture)
        // Додає створений жест до view щоб обробляти тапи
    }
    
    // Setup text field delegates
    private func setupDelegates() { // приватний метод для встановлення делегатів
        reversTextField.delegate = self // встановлюю делегат для reversTextField для обропки подій та дій які будуть відбуватись у текст філд
        ignoreTextField.delegate = self // встановлюю делегат для ignoreTextField для обропки подій та дій які будуть відбуватись у текст філд
    }
    
    // Handler for text field change
    @objc func textFieldDidChange(_ textField: UITextField) { // метод для обробки змін у текстовому полі
        didUpdateIgnoreTextField(textField.text ?? "") // викликає метод didUpdateIgnoreTextField з текстом з textField або порожнім рядком, якщо текст є nil
    }
    
    // Dismiss keyboard when tapping outside the text field
    @objc private func dismissKeyboard() { // метод для селектора у setupGestures() для закриття клавіатури
        view.endEditing(true) // закриває клавіатуру приховуючи її
    }
}

// Extension for handling text field delegate methods
extension MainViewController: UITextFieldDelegate {   // естеншин для обробки методів делегата текстових полів
    // Method for handling text changes
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool { // метод для обробки змін у тексті текстового поля
        let currentText = textField.text ?? "" // отримує поточний текст з текстового поля або порожній рядок якщо текст є nil
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)  // створює новий рядок, замінюючи вказаний діапазон range на новий текст string
        updateText(with: updatedText)  // оновлює текст за допомогою методу updateText, передаючи новий текст
        return true // Повертає true, що дозволяє зміну тексту
    }
    
    // Method for handling return key press
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { // метод для обробки натискання клавіші Return (Enter)
        textField.resignFirstResponder() // знімає фокус з текстового поля, ховаючи клавіатуру
        return true // повертає true, що дозволяє завершити обробку натискання клавіші Return
    }
}
