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
        print("[KeyboardView] INITIALIZING KeyboardView")
        self.keyboardViewController = keyboardViewController
        super.init(frame: .zero)
        self.delegate = keyboardViewController
        print("[KeyboardView] Delegate set to: \(delegate != nil)")
        setupKeyboard()
        print("[KeyboardView] INITIALIZATION COMPLETE")
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
        
        // Initially disable all buttons until keyboard is ready
        updateButtonStates(enabled: false)
        
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
                shiftButton = createStandardButton(text: "⇧", color: colors.special, action: #selector(shiftPressedDisabled))
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
        
        // SIMPLIFIED touch event configuration - only the primary action
        button.addTarget(self, action: action, for: .touchUpInside)
        
        // Enable modern visual feedback for iOS 15+
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.filled()
            config.baseBackgroundColor = color
            config.title = text
            config.baseForegroundColor = .label
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                // Reduced font size to prevent truncation
                outgoing.font = UIFont.systemFont(ofSize: 16, weight: .medium)
                return outgoing
            }
            config.cornerStyle = .small
            config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 4, bottom: 8, trailing: 4)
            button.configuration = config
        } else {
            button.showsTouchWhenHighlighted = true
            button.adjustsImageWhenHighlighted = true
        }
        
        // Standard constraints
        button.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        
        print("[KeyboardView] 🔲 Created SIMPLIFIED button '\(text)' - action: \(action)")
        
        // Validate button event configuration for critical buttons
        if text == "space" || text == "return" {
            print("[KeyboardView] 🔍 CRITICAL BUTTON '\(text)' - SIMPLIFIED CONFIG")
            print("[KeyboardView]    - Only .touchUpInside: \(action)")
            print("[KeyboardView]    - Built-in visual feedback enabled")
        }
        
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
        
        // Check if keyboard is ready
        guard isKeyboardReady() else {
            debugLog("❌ Keyboard not ready, programmer key '\(text)' action blocked")
            return
        }
        
        debugLog("🔢 Programmer key pressed: '\(text)'")
        delegate?.insertText(text)
    }
    
    @objc private func alphabetKeyPressed(_ sender: UIButton) {
        guard let text = sender.currentTitle else { return }
        
        // Check if keyboard is ready
        guard isKeyboardReady() else {
            debugLog("❌ Keyboard not ready, alphabet key '\(text)' action blocked")
            return
        }
        
        debugLog("🔤 Alphabet key pressed: '\(text)' (lowercase only)")
        delegate?.insertText(text)
    }
    
    @objc private func shiftPressedDisabled() {
        debugLog("⇧ Shift key pressed but disabled - no action taken")
        // Shift functionality completely disabled - visual feedback only
    }
    
    @objc private func backspacePressed() {
        debugLog("⌫ Backspace pressed")
        
        // Check if keyboard is ready
        guard isKeyboardReady() else {
            debugLog("❌ Keyboard not ready, backspace action blocked")
            return
        }
        
        delegate?.deleteBackward()
    }
    
    @objc private func spacePressed() {
        print("[KeyboardView] 🚀 SPACE BUTTON ACTION CALLED!")
        debugLog("🚀 Space pressed - simplified logic")
        
        // Validate delegate connection
        guard let delegate = delegate else { 
            print("[KeyboardView] ❌ Space pressed but delegate is nil")
            debugLog("❌ Space pressed but delegate is nil")
            return 
        }
        
        // Check if keyboard is ready through the view controller
        guard let keyboardVC = keyboardViewController,
              keyboardVC.isReady() else {
            print("[KeyboardView] ❌ Keyboard not ready, space action blocked")
            debugLog("❌ Keyboard not ready, space action blocked")
            return
        }
        
        print("[KeyboardView] ✅ Space button calling delegate.insertText")
        delegate.insertText(" ")
        print("[KeyboardView] ✅ Space insertion call completed")
        debugLog("✅ Space inserted successfully")
        
        // Provide haptic feedback
        if #available(iOS 10.0, *) {
            let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
            feedbackGenerator.impactOccurred()
        }
    }
    
    @objc private func returnPressed() {
        print("[KeyboardView] ↵ RETURN BUTTON ACTION CALLED!")
        debugLog("↵ Return pressed - simplified logic")
        
        // Validate delegate connection
        guard let delegate = delegate else {
            print("[KeyboardView] ❌ Return pressed but delegate is nil") 
            debugLog("❌ Return pressed but delegate is nil") 
            return 
        }
        
        // Check if keyboard is ready through the view controller
        guard let keyboardVC = keyboardViewController,
              keyboardVC.isReady() else {
            print("[KeyboardView] ❌ Keyboard not ready, return action blocked")
            debugLog("❌ Keyboard not ready, return action blocked")
            return
        }
        
        print("[KeyboardView] ✅ Return button calling delegate.insertReturn")
        delegate.insertReturn()
        print("[KeyboardView] ✅ Return insertion call completed")
        debugLog("✅ Return inserted successfully")
        
        // Provide haptic feedback
        if #available(iOS 10.0, *) {
            let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
            feedbackGenerator.impactOccurred()
        }
    }
    
    
    // MARK: - Button State Management
    
    private func updateButtonStates(enabled: Bool) {
        debugLog("🔄 Updating button states: \(enabled ? "enabled" : "disabled")")
        
        // Update programmer buttons
        for row in programmerButtons {
            for button in row {
                button.isEnabled = enabled
                button.alpha = enabled ? 1.0 : 0.6
            }
        }
        
        // Update alphabet buttons
        for row in alphabetButtons {
            for button in row {
                button.isEnabled = enabled
                button.alpha = enabled ? 1.0 : 0.6
            }
        }
        
        // Update special buttons
        shiftButton?.isEnabled = enabled
        shiftButton?.alpha = enabled ? 1.0 : 0.6
        
        backspaceButton?.isEnabled = enabled
        backspaceButton?.alpha = enabled ? 1.0 : 0.6
        
        // Update bottom action buttons
        spaceButton?.isEnabled = enabled
        spaceButton?.alpha = enabled ? 1.0 : 0.6
        
        returnButton?.isEnabled = enabled
        returnButton?.alpha = enabled ? 1.0 : 0.6
        
        debugLog("✅ Button states updated")
    }
    
    // MARK: - Public Interface for Keyboard State
    
    func enableButtons() {
        updateButtonStates(enabled: true)
        debugLog("🎯 All buttons are now ENABLED and ready for input")
    }
    
    func disableButtons() {
        updateButtonStates(enabled: false)
        debugLog("⏸️ All buttons are now DISABLED - waiting for keyboard to be ready")
    }
    
    func isKeyboardReady() -> Bool {
        guard let keyboardVC = keyboardViewController else { return false }
        return keyboardVC.isReady()
    }
    
    // MARK: - Visual Feedback (Using Built-in UIButton Behavior)
    // Removed custom touch event handlers - using built-in button visual feedback
    
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