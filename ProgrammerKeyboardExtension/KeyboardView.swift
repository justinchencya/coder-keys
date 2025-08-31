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
    
    // Keyboard state management
    private var isShiftEnabled = false
    private var shiftButton: UIButton?
    
    // Key layout definitions - lowercase by default
    private let alphabetKeys = [
        ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
        ["a", "s", "d", "f", "g", "h", "j", "k", "l"],
        ["z", "x", "c", "v", "b", "n", "m"]
    ]
    
    // Number and symbol layout for programmer keyboard - reorganized for logical grouping
    private let numberSymbolKeys = [
        ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
        ["+", "-", "*", "/", "=", "<", ">", "!", "&", "|"],
        ["(", ")", "[", "]", "{", "}", "'", "\"", ";", ":"]
    ]
    
    private var stackView: UIStackView!
    private var alphabetButtons: [[UIButton]] = []
    private var currentKeyButtons: [[UIButton]] = []
    
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
        createMainKeyRows()
        createBottomRow()
    }
    
    private func createMainKeyRows() {
        // Clear existing rows
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        currentKeyButtons.removeAll()
        
        // Always show number/programmer keys at the top first
        for (_, row) in numberSymbolKeys.enumerated() {
            let rowStack = createRowStackView()
            var buttonRow: [UIButton] = []
            
            // Add main keys for the row
            for key in row {
                let color = getColorForNumberSymbolKey(key)
                let button = createKeyButton(text: key, color: color)
                buttonRow.append(button)
                rowStack.addArrangedSubview(button)
            }
            
            currentKeyButtons.append(buttonRow)
            stackView.addArrangedSubview(rowStack)
        }
        
        // Then add alphabet keys below
        for (rowIndex, row) in alphabetKeys.enumerated() {
            let rowStack = createRowStackView()
            var buttonRow: [UIButton] = []
            
            // Add left-side button for appropriate rows
            if rowIndex == 1 { // Second row (a-l)
                rowStack.addArrangedSubview(createSpacer(width: 20)) // Offset for visual alignment
            } else if rowIndex == 2 { // Third row (z-m)
                let shiftButton = createShiftButton()
                rowStack.addArrangedSubview(shiftButton)
            }
            
            // Add main keys for the row
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
    }
    
    private func createBottomRow() {
        // Bottom row: [    space    ] [return] - equal sizes  
        let bottomRowStack = createRowStackView()
        bottomRowStack.distribution = .fillEqually // Equal button sizes
        
        // Space bar
        let spaceButton = createSpaceButton()
        bottomRowStack.addArrangedSubview(spaceButton)
        
        // Return button  
        let returnButton = createReturnButton()
        bottomRowStack.addArrangedSubview(returnButton)
        
        stackView.addArrangedSubview(bottomRowStack)
    }
    
    private func getColorForNumberSymbolKey(_ key: String) -> UIColor {
        switch key {
        case "0"..."9":
            return colors.number
        case "(", ")", "[", "]", "{", "}":
            return colors.bracket
        case "+", "-", "*", "/", "=", "<", ">", "!":
            return colors.operator
        case "\"", "'":
            return colors.quote
        case "&", "|", ";", ":":
            return colors.punctuation
        case "_":
            return colors.underscore
        default:
            return colors.punctuation
        }
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
    
    
    private func createEmojiButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("😊", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = colors.special
        button.layer.cornerRadius = 5
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 0
        
        button.addTarget(self, action: #selector(emojiPressed), for: .touchUpInside)
        button.addTarget(self, action: #selector(keyTouchDown(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(keyTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        button.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        button.widthAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
        
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
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 0
        
        button.addTarget(self, action: #selector(spacePressed), for: .touchUpInside)
        button.addTarget(self, action: #selector(keyTouchDown(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(keyTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel, .touchDragExit])
        
        button.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        
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
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 0
        
        button.addTarget(self, action: #selector(returnPressed), for: .touchUpInside)
        button.addTarget(self, action: #selector(keyTouchDown(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(keyTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel, .touchDragExit])
        
        button.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        
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
    
    
    @objc private func emojiPressed() {
        // Placeholder for emoji functionality
        // For now, just add a smiley face
        delegate?.insertText("😊")
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
        // Immediate feedback without animation for better responsiveness
        sender.alpha = 0.5
        sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
    }
    
    @objc private func keyTouchUp(_ sender: UIButton) {
        // Quick animation back to normal state
        UIView.animate(withDuration: 0.05, delay: 0, options: [.curveEaseOut], animations: {
            sender.alpha = 1.0
            sender.transform = CGAffineTransform.identity
        })
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