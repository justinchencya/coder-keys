import UIKit

protocol KeyboardViewDelegate: AnyObject {
    func insertText(_ text: String)
    func deleteBackward()
    func insertReturn()
    func switchToNextInputMode()
}

class KeyboardView: UIView {
    
    weak var delegate: KeyboardViewDelegate?
    private weak var keyboardViewController: KeyboardViewController?
    
    // Color scheme for programmer keyboard
    private let colors = KeyColors()
    
    // Key layout definitions
    private let alphabetKeys = [
        ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
        ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
        ["Z", "X", "C", "V", "B", "N", "M"]
    ]
    
    private let numberKeys = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    private let operatorKeys = ["+", "-", "*", "/", "=", "(", ")", "[", "]", "{", "}"]
    private let punctuationKeys = ["<", ">", ".", ",", ";", ":", "_", "\"", "'"]
    
    private var stackView: UIStackView!
    
    init(keyboardViewController: KeyboardViewController) {
        self.keyboardViewController = keyboardViewController
        super.init(frame: .zero)
        self.delegate = keyboardViewController
        setupKeyboard()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupKeyboard() {
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
        
        createKeyboardRows()
    }
    
    private func createKeyboardRows() {
        // Alphabet rows
        for row in alphabetKeys {
            let rowStack = createRowStackView()
            
            if row.count == 9 { // Second row (A-L)
                rowStack.addArrangedSubview(createSpacer(width: 20)) // Offset for visual alignment
            } else if row.count == 7 { // Third row (Z-M)
                rowStack.addArrangedSubview(createSpacer(width: 40)) // Larger offset
            }
            
            for key in row {
                let button = createKeyButton(text: key, color: colors.alphabet)
                rowStack.addArrangedSubview(button)
            }
            
            // Add backspace to the third row
            if row.count == 7 {
                let backspaceButton = createBackspaceButton()
                rowStack.addArrangedSubview(backspaceButton)
            }
            
            stackView.addArrangedSubview(rowStack)
        }
        
        // Number row
        let numberRowStack = createRowStackView()
        for key in numberKeys {
            let button = createKeyButton(text: key, color: colors.number)
            numberRowStack.addArrangedSubview(button)
        }
        stackView.addArrangedSubview(numberRowStack)
        
        // Operator row
        let operatorRowStack = createRowStackView()
        for key in operatorKeys {
            let color = key.contains(["(", ")", "[", "]", "{", "}"]) ? colors.bracket : colors.operator
            let button = createKeyButton(text: key, color: color)
            operatorRowStack.addArrangedSubview(button)
        }
        stackView.addArrangedSubview(operatorRowStack)
        
        // Punctuation row
        let punctuationRowStack = createRowStackView()
        for key in punctuationKeys {
            let color: UIColor
            if key == "\"" || key == "'" {
                color = colors.quote
            } else if key == "_" {
                color = colors.underscore
            } else {
                color = colors.punctuation
            }
            let button = createKeyButton(text: key, color: color)
            punctuationRowStack.addArrangedSubview(button)
        }
        stackView.addArrangedSubview(punctuationRowStack)
        
        // Bottom row with special keys
        let bottomRowStack = createRowStackView()
        
        // Globe button
        let globeButton = createSpecialButton(title: "🌐") { [weak self] in
            self?.delegate?.switchToNextInputMode()
        }
        bottomRowStack.addArrangedSubview(globeButton)
        
        // Space bar
        let spaceButton = createSpaceButton()
        bottomRowStack.addArrangedSubview(spaceButton)
        
        // Return button  
        let returnButton = createSpecialButton(title: "↵") { [weak self] in
            self?.delegate?.insertReturn()
        }
        bottomRowStack.addArrangedSubview(returnButton)
        
        stackView.addArrangedSubview(bottomRowStack)
    }
    
    private func createRowStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 6
        return stackView
    }
    
    private func createKeyButton(text: String, color: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = color
        button.layer.cornerRadius = 5
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 0
        
        button.addTarget(self, action: #selector(keyPressed(_:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(keyTouchDown(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(keyTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        // Set minimum height
        button.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        
        return button
    }
    
    private func createBackspaceButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("⌫", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = colors.special
        button.layer.cornerRadius = 5
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 0
        
        button.addTarget(self, action: #selector(backspacePressed), for: .touchUpInside)
        button.addTarget(self, action: #selector(keyTouchDown(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(keyTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        button.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        button.widthAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
        
        return button
    }
    
    private func createSpaceButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("space", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.secondaryLabel, for: .normal)
        button.backgroundColor = colors.special
        button.layer.cornerRadius = 5
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 0
        
        button.addTarget(self, action: #selector(spacePressed), for: .touchUpInside)
        button.addTarget(self, action: #selector(keyTouchDown(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(keyTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        button.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        
        return button
    }
    
    private func createSpecialButton(title: String, action: @escaping () -> Void) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = colors.special
        button.layer.cornerRadius = 5
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 0
        
        button.addAction(UIAction { _ in action() }, for: .touchUpInside)
        button.addTarget(self, action: #selector(keyTouchDown(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(keyTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        button.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        button.widthAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        
        return button
    }
    
    private func createSpacer(width: CGFloat) -> UIView {
        let spacer = UIView()
        spacer.widthAnchor.constraint(equalToConstant: width).isActive = true
        return spacer
    }
    
    @objc private func keyPressed(_ sender: UIButton) {
        guard let text = sender.currentTitle else { return }
        delegate?.insertText(text)
    }
    
    @objc private func backspacePressed() {
        delegate?.deleteBackward()
    }
    
    @objc private func spacePressed() {
        delegate?.insertText(" ")
    }
    
    @objc private func keyTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.alpha = 0.3
        }
    }
    
    @objc private func keyTouchUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.alpha = 1.0
        }
    }
    
    override func sizeToFit() {
        super.sizeToFit()
        frame.size.height = 280 // Fixed height for keyboard
    }
}

// MARK: - KeyColors
private struct KeyColors {
    let alphabet = UIColor.systemGray5
    let number = UIColor.systemOrange.withAlphaComponent(0.7)
    let `operator` = UIColor.systemRed.withAlphaComponent(0.7)
    let bracket = UIColor.systemBlue.withAlphaComponent(0.7)
    let punctuation = UIColor.systemPurple.withAlphaComponent(0.7)
    let quote = UIColor.systemYellow.withAlphaComponent(0.7)
    let underscore = UIColor.systemGreen.withAlphaComponent(0.7)
    let special = UIColor.systemGray4
}

// MARK: - String Extension
private extension String {
    func contains(_ strings: [String]) -> Bool {
        return strings.contains(self)
    }
}