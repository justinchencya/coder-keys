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
    
    // MARK: - Separated Architecture Components
    
    // Main layout container
    private var stackView: UIStackView!
    
    // Programmer Keys Section (Top)
    private var programmerSection: UIStackView!
    private var programmerButtons: [[UIButton]] = []
    
    // Alphabet Keys Section (Middle)  
    private var alphabetSection: UIStackView!
    private var alphabetButtons: [[UIButton]] = []
    private var isShiftEnabled = false
    private var shiftButton: UIButton?
    private var backspaceButton: UIButton?
    
    // Bottom Action Section (Space/Return)
    private var bottomActionSection: UIStackView!
    private var spaceButton: UIButton?
    private var returnButton: UIButton?
    
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
    
    // Debug logging
    private let enableDebugLogging = true
    
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
        debugLog("🚀 Setting up keyboard with separated architecture")
        
        // Create main container
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill  // Changed from .fillEqually to allow custom sizing
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
        
        // Create independent sections
        createProgrammerKeySection()
        createAlphabetKeySection()
        createBottomActionSection()
        
        debugLog("✅ Keyboard setup complete - all sections created independently")
    }
    
    // MARK: - Programmer Keys Section (Top Rows)
    private func createProgrammerKeySection() {
        debugLog("🔢 Creating programmer key section")
        
        programmerSection = UIStackView()
        programmerSection.axis = .vertical
        programmerSection.distribution = .fillEqually
        programmerSection.spacing = 8
        
        programmerButtons.removeAll()
        
        for (_, row) in numberSymbolKeys.enumerated() {
            let rowStack = createRowStackView()
            var buttonRow: [UIButton] = []
            
            for key in row {
                let color = getColorForNumberSymbolKey(key)
                let button = createStandardButton(text: key, color: color, action: #selector(programmerKeyPressed(_:)))
                buttonRow.append(button)
                rowStack.addArrangedSubview(button)
            }
            
            programmerButtons.append(buttonRow)
            programmerSection.addArrangedSubview(rowStack)
        }
        
        stackView.addArrangedSubview(programmerSection)
        debugLog("✅ Programmer section created with \(programmerButtons.count) rows")
    }
    
    // MARK: - Alphabet Keys Section (Middle Rows)
    private func createAlphabetKeySection() {
        debugLog("🔤 Creating alphabet key section")
        
        alphabetSection = UIStackView()
        alphabetSection.axis = .vertical
        alphabetSection.distribution = .fillEqually
        alphabetSection.spacing = 8
        
        alphabetButtons.removeAll()
        
        for (rowIndex, row) in alphabetKeys.enumerated() {
            let rowStack = createRowStackView()
            var buttonRow: [UIButton] = []
            
            // Add left-side elements for appropriate rows
            if rowIndex == 1 { // Second row (a-l)
                rowStack.addArrangedSubview(createSpacer(width: 20))
            } else if rowIndex == 2 { // Third row (z-m)
                shiftButton = createStandardButton(text: "⇧", color: colors.special, action: #selector(shiftPressed))
                shiftButton?.titleLabel?.font = UIFont.systemFont(ofSize: 20)
                shiftButton?.widthAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
                rowStack.addArrangedSubview(shiftButton!)
            }
            
            // Add alphabet keys for the row
            for key in row {
                let button = createStandardButton(text: key, color: colors.alphabet, action: #selector(alphabetKeyPressed(_:)))
                buttonRow.append(button)
                rowStack.addArrangedSubview(button)
            }
            
            // Add backspace to the third alphabet row
            if rowIndex == 2 {
                backspaceButton = createStandardButton(text: "⌫", color: colors.special, action: #selector(backspacePressed))
                backspaceButton?.titleLabel?.font = UIFont.systemFont(ofSize: 22)
                backspaceButton?.widthAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
                rowStack.addArrangedSubview(backspaceButton!)
            }
            
            alphabetButtons.append(buttonRow)
            alphabetSection.addArrangedSubview(rowStack)
        }
        
        stackView.addArrangedSubview(alphabetSection)
        debugLog("✅ Alphabet section created with \(alphabetButtons.count) rows")
    }
    
    // MARK: - Bottom Action Section (Space/Return)
    private func createBottomActionSection() {
        debugLog("⌨️ Creating bottom action section")
        
        bottomActionSection = UIStackView()
        bottomActionSection.axis = .horizontal
        bottomActionSection.distribution = .fillEqually
        bottomActionSection.spacing = 6
        
        // Create space button - NEVER recreated
        spaceButton = createStandardButton(text: "space", color: colors.special, action: #selector(spacePressed))
        spaceButton?.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        bottomActionSection.addArrangedSubview(spaceButton!)
        
        // Create return button - NEVER recreated
        returnButton = createStandardButton(text: "return", color: colors.special, action: #selector(returnPressed))
        returnButton?.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        bottomActionSection.addArrangedSubview(returnButton!)
        
        // Set proper height constraint for bottom row to match other keyboard rows
        bottomActionSection.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        stackView.addArrangedSubview(bottomActionSection)
        debugLog("✅ Bottom action section created - space and return buttons are persistent")
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
    
    // MARK: - Standardized Button Creation & Touch Handling
    
    private func createRowStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 6
        return stackView
    }
    
    private func createStandardButton(text: String, color: UIColor, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = color
        button.layer.cornerRadius = 5
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 0
        
        // STANDARDIZED touch event configuration - ALL buttons use identical setup
        button.addTarget(self, action: action, for: .touchUpInside)
        button.addTarget(self, action: #selector(keyTouchDown(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(keyTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        // Standard constraints
        button.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        
        debugLog("🔲 Created button '\(text)' with standardized touch handling")
        return button
    }
    
    private func createSpacer(width: CGFloat) -> UIView {
        let spacer = UIView()
        spacer.widthAnchor.constraint(equalToConstant: width).isActive = true
        return spacer
    }
    
    // MARK: - Button Action Methods (Separated by Section)
    
    @objc private func programmerKeyPressed(_ sender: UIButton) {
        guard let text = sender.currentTitle else { return }
        debugLog("🔢 Programmer key pressed: '\(text)'")
        delegate?.insertText(text)
    }
    
    @objc private func alphabetKeyPressed(_ sender: UIButton) {
        guard let text = sender.currentTitle else { return }
        let outputText = isShiftEnabled ? text.uppercased() : text
        debugLog("🔤 Alphabet key pressed: '\(text)' -> '\(outputText)' (shift: \(isShiftEnabled))")
        delegate?.insertText(outputText)
        
        // Auto-disable shift after single use (like iOS keyboard) - ONLY affects alphabet section
        if isShiftEnabled {
            toggleShiftStateOnly()
        }
    }
    
    @objc private func shiftPressed() {
        debugLog("🚨 SHIFT BUTTON PRESSED - Starting comprehensive check")
        debugLog("   - Current shift state: \(isShiftEnabled)")
        debugLog("   - Space button exists: \(spaceButton != nil)")
        debugLog("   - Return button exists: \(returnButton != nil)")
        debugLog("   - Space button enabled: \(spaceButton?.isEnabled ?? false)")
        debugLog("   - Return button enabled: \(returnButton?.isEnabled ?? false)")
        
        toggleShiftStateOnly()
        
        debugLog("🔍 POST-SHIFT state check:")
        debugLog("   - New shift state: \(isShiftEnabled)")
        debugLog("   - Space button still enabled: \(spaceButton?.isEnabled ?? false)")
        debugLog("   - Return button still enabled: \(returnButton?.isEnabled ?? false)")
    }
    
    @objc private func backspacePressed() {
        debugLog("⌫ Backspace pressed")
        delegate?.deleteBackward()
    }
    
    @objc private func spacePressed() {
        debugLog("🚨 SPACE BUTTON PRESSED - Starting comprehensive check")
        debugLog("   - Delegate exists: \(delegate != nil)")
        debugLog("   - KeyboardViewController exists: \(keyboardViewController != nil)")
        debugLog("   - Current shift state: \(isShiftEnabled)")
        
        guard let delegate = delegate else { 
            debugLog("❌ Space pressed but delegate is nil")
            return 
        }
        
        debugLog("✅ Space delegate confirmed - inserting space character")
        delegate.insertText(" ")
        debugLog("✅ Space insertion completed successfully")
        
        // Provide haptic feedback
        if #available(iOS 10.0, *) {
            let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
            feedbackGenerator.impactOccurred()
            debugLog("✅ Space haptic feedback triggered")
        }
    }
    
    @objc private func returnPressed() {
        debugLog("🚨 RETURN BUTTON PRESSED - Starting comprehensive check")
        debugLog("   - Delegate exists: \(delegate != nil)")
        debugLog("   - KeyboardViewController exists: \(keyboardViewController != nil)")
        debugLog("   - Current shift state: \(isShiftEnabled)")
        
        guard let delegate = delegate else {
            debugLog("❌ Return pressed but delegate is nil") 
            return 
        }
        
        debugLog("✅ Return delegate confirmed - inserting return")
        delegate.insertReturn()
        debugLog("✅ Return insertion completed successfully")
        
        // Provide haptic feedback
        if #available(iOS 10.0, *) {
            let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
            feedbackGenerator.impactOccurred()
            debugLog("✅ Return haptic feedback triggered")
        }
    }
    
    // MARK: - Isolated State Management (Only Affects Alphabet Section)
    
    private func toggleShiftStateOnly() {
        debugLog("🔄 Toggling shift state: \(isShiftEnabled) -> \(!isShiftEnabled)")
        isShiftEnabled.toggle()
        updateAlphabetSectionOnly()
    }
    
    private func updateAlphabetSectionOnly() {
        debugLog("📝 Updating alphabet section only - shift: \(isShiftEnabled)")
        
        // Update shift button appearance
        if isShiftEnabled {
            shiftButton?.backgroundColor = colors.shiftActive
        } else {
            shiftButton?.backgroundColor = colors.special
        }
        
        // Update ONLY alphabet button display text - NO other sections affected
        for (rowIndex, row) in alphabetButtons.enumerated() {
            for (keyIndex, button) in row.enumerated() {
                let originalKey = alphabetKeys[rowIndex][keyIndex]
                let displayText = isShiftEnabled ? originalKey.uppercased() : originalKey
                button.setTitle(displayText, for: .normal)
            }
        }
        
        debugLog("✅ Alphabet section updated - \(programmerButtons.count) programmer rows UNTOUCHED, space/return UNTOUCHED")
    }
    
    // MARK: - Standardized Touch Event Handling
    
    @objc private func keyTouchDown(_ sender: UIButton) {
        let buttonTitle = sender.currentTitle ?? "unknown"
        debugLog("👇 Touch down on button: '\(buttonTitle)'")
        
        // Track if this is a critical button
        if buttonTitle == "space" || buttonTitle == "return" {
            debugLog("🔍 Critical button '\(buttonTitle)' touch down - detailed tracking")
            debugLog("   - Button enabled: \(sender.isEnabled)")
            debugLog("   - Button user interaction: \(sender.isUserInteractionEnabled)")
            debugLog("   - Button frame: \(sender.frame)")
            debugLog("   - Button superview: \(sender.superview != nil)")
        }
        
        // Immediate visual feedback for better responsiveness
        sender.alpha = 0.5
        sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
    }
    
    @objc private func keyTouchUp(_ sender: UIButton) {
        let buttonTitle = sender.currentTitle ?? "unknown"
        debugLog("👆 Touch up on button: '\(buttonTitle)'")
        
        // Track if this is a critical button
        if buttonTitle == "space" || buttonTitle == "return" {
            debugLog("🔍 Critical button '\(buttonTitle)' touch up - detailed tracking")
        }
        
        // Consistent animation back to normal state for all buttons
        UIView.animate(withDuration: 0.05, delay: 0, options: [.curveEaseOut, .allowUserInteraction], animations: {
            sender.alpha = 1.0
            sender.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    // MARK: - Debug Instrumentation
    
    private func debugLog(_ message: String) {
        if enableDebugLogging {
            print("[KeyboardView Debug] \(message)")
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