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
    
    // Shift state management
    private var isShiftEnabled = false
    private var shiftButton: UIButton?
    
    // Key layout definitions - lowercase by default
    private let alphabetKeys = [
        ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
        ["a", "s", "d", "f", "g", "h", "j", "k", "l"],
        ["z", "x", "c", "v", "b", "n", "m"]
    ]
    
    private let numberKeys = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    private let operatorKeys = ["+", "-", "*", "/", "=", "(", ")", "[", "]", "{", "}"]
    private let punctuationKeys = ["<", ">", ".", ",", ";", ":", "_", "\"", "'"]
    
    private var stackView: UIStackView!
    private var alphabetButtons: [[UIButton]] = []
    
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
        // Number row (moved to top)
        let numberRowStack = createRowStackView()
        for key in numberKeys {
            let button = createKeyButton(text: key, color: colors.number)
            numberRowStack.addArrangedSubview(button)
        }
        stackView.addArrangedSubview(numberRowStack)
        
        // Operator row (moved above alphabet)
        let operatorRowStack = createRowStackView()
        for key in operatorKeys {
            let color = key.contains(["(", ")", "[", "]", "{", "}"]) ? colors.bracket : colors.operator
            let button = createKeyButton(text: key, color: color)
            operatorRowStack.addArrangedSubview(button)
        }
        stackView.addArrangedSubview(operatorRowStack)
        
        // Punctuation row (moved above alphabet)
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
        
        // Alphabet rows (now at bottom)
        for (rowIndex, row) in alphabetKeys.enumerated() {
            let rowStack = createRowStackView()
            var buttonRow: [UIButton] = []
            
            // Add shift button to first alphabet row
            if rowIndex == 0 {
                let shift = createShiftButton()
                rowStack.addArrangedSubview(shift)
            } else if rowIndex == 1 { // Second row (a-l)
                rowStack.addArrangedSubview(createSpacer(width: 20)) // Offset for visual alignment
            } else if rowIndex == 2 { // Third row (z-m)
                rowStack.addArrangedSubview(createSpacer(width: 40)) // Larger offset
            }
            
            for key in row {
                let button = createAlphabetButton(text: key, color: colors.alphabet)
                buttonRow.append(button)
                rowStack.addArrangedSubview(button)
            }
            
            // Add backspace to the third alphabet row
            if rowIndex == 2 {
                let backspaceButton = createBackspaceButton()
                rowStack.addArrangedSubview(backspaceButton)
            }
            
            alphabetButtons.append(buttonRow)
            stackView.addArrangedSubview(rowStack)
        }
        
        // Bottom row with special keys (no globe button)
        let bottomRowStack = createRowStackView()
        
        // Space bar (wider)
        let spaceButton = createSpaceButton()
        bottomRowStack.addArrangedSubview(spaceButton)
        
        // Return button  
        let returnButton = createReturnButton()
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
    
    private func createAlphabetButton(text: String, color: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = color
        button.layer.cornerRadius = 5
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 0
        
        button.addTarget(self, action: #selector(alphabetKeyPressed(_:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(keyTouchDown(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(keyTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        // Set minimum height
        button.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        
        return button
    }
    
    private func createShiftButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("⇧", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = colors.special
        button.layer.cornerRadius = 5
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 0
        
        button.addTarget(self, action: #selector(shiftPressed), for: .touchUpInside)
        button.addTarget(self, action: #selector(keyTouchDown(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(keyTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        button.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        button.widthAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
        
        shiftButton = button
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
        // Make space button wider to fill more space since globe button is removed
        button.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        return button
    }
    
    private func createReturnButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("return", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = colors.special
        button.layer.cornerRadius = 5
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 0
        
        button.addTarget(self, action: #selector(returnPressed), for: .touchUpInside)
        button.addTarget(self, action: #selector(keyTouchDown(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(keyTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        button.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        button.widthAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true
        
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
    
    @objc private func alphabetKeyPressed(_ sender: UIButton) {
        guard let text = sender.currentTitle else { return }
        let outputText = isShiftEnabled ? text.uppercased() : text
        delegate?.insertText(outputText)
        
        // Auto-disable shift after single use (like iOS keyboard)
        if isShiftEnabled {
            toggleShift()
        }
    }
    
    @objc private func shiftPressed() {
        toggleShift()
    }
    
    @objc private func backspacePressed() {
        delegate?.deleteBackward()
    }
    
    @objc private func spacePressed() {
        delegate?.insertText(" ")
    }
    
    @objc private func returnPressed() {
        delegate?.insertReturn()
    }
    
    private func toggleShift() {
        isShiftEnabled.toggle()
        updateShiftButton()
        updateAlphabetButtons()
    }
    
    private func updateShiftButton() {
        if isShiftEnabled {
            shiftButton?.backgroundColor = colors.shiftActive
            shiftButton?.setTitle("⇧", for: .normal)
        } else {
            shiftButton?.backgroundColor = colors.special
            shiftButton?.setTitle("⇧", for: .normal)
        }
    }
    
    private func updateAlphabetButtons() {
        for (rowIndex, row) in alphabetButtons.enumerated() {
            for (keyIndex, button) in row.enumerated() {
                let originalKey = alphabetKeys[rowIndex][keyIndex]
                let displayText = isShiftEnabled ? originalKey.uppercased() : originalKey
                button.setTitle(displayText, for: .normal)
            }
        }
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
    let shiftActive = UIColor.systemBlue.withAlphaComponent(0.8)
}

// MARK: - String Extension
private extension String {
    func contains(_ strings: [String]) -> Bool {
        return strings.contains(self)
    }
}