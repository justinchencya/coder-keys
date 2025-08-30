import UIKit

protocol KeyboardViewDelegate: AnyObject {
    func keyTapped(_ key: String)
    func backspaceTapped()
    func spaceTapped()
    func returnTapped()
    func nextKeyboardTapped()
}

class KeyboardView: UIView {
    
    weak var delegate: KeyboardViewDelegate?
    
    // MARK: - Keyboard Layout Constants
    private let keyHeight: CGFloat = 50
    private let keySpacing: CGFloat = 6
    private let rowSpacing: CGFloat = 8
    
    // MARK: - Key Arrays
    private let firstRow = ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"]
    private let secondRow = ["a", "s", "d", "f", "g", "h", "j", "k", "l"]
    private let thirdRow = ["z", "x", "c", "v", "b", "n", "m"]
    
    // Programmer keys with Python color coding
    private let programmerKeys = [
        ("0", UIColor.systemOrange),      // Numbers - Orange
        ("1", UIColor.systemOrange),
        ("2", UIColor.systemOrange),
        ("3", UIColor.systemOrange),
        ("4", UIColor.systemOrange),
        ("5", UIColor.systemOrange),
        ("6", UIColor.systemOrange),
        ("7", UIColor.systemOrange),
        ("8", UIColor.systemOrange),
        ("9", UIColor.systemOrange),
        ("+", UIColor.systemRed),         // Operators - Red
        ("-", UIColor.systemRed),
        ("*", UIColor.systemRed),
        ("/", UIColor.systemRed),
        ("=", UIColor.systemRed),
        ("(", UIColor.systemBlue),        // Brackets - Blue
        (")", UIColor.systemBlue),
        ("[", UIColor.systemBlue),
        ("]", UIColor.systemBlue),
        ("{", UIColor.systemBlue),
        ("}", UIColor.systemBlue),
        ("<", UIColor.systemBlue),
        (">", UIColor.systemBlue),
        (".", UIColor.systemPurple),      // Punctuation - Purple
        (",", UIColor.systemPurple),
        (";", UIColor.systemPurple),
        (":", UIColor.systemPurple),
        ("_", UIColor.systemGreen),       // Underscore - Green
        ("\"", UIColor.systemYellow),     // Quotes - Yellow
        ("'", UIColor.systemYellow)
    ]
    
    // MARK: - UI Elements
    private var keyButtons: [UIButton] = []
    private var programmerKeyButtons: [UIButton] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupKeyboard()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupKeyboard()
    }
    
    private func setupKeyboard() {
        backgroundColor = UIColor.systemGray6
        
        // Create alphabet keys
        createAlphabetKeys()
        
        // Create programmer keys
        createProgrammerKeys()
        
        // Create function keys (space, return, backspace, next keyboard)
        createFunctionKeys()
    }
    
    private func createAlphabetKeys() {
        // First row (q-p)
        createKeyRow(keys: firstRow, yPosition: keySpacing)
        
        // Second row (a-l) - centered
        let secondRowWidth = CGFloat(secondRow.count) * (keyHeight + keySpacing) - keySpacing
        let secondRowX = (bounds.width - secondRowWidth) / 2
        createKeyRow(keys: secondRow, yPosition: keySpacing + keyHeight + rowSpacing, xOffset: secondRowX)
        
        // Third row (z-m) - centered
        let thirdRowWidth = CGFloat(thirdRow.count) * (keyHeight + keySpacing) - keySpacing
        let thirdRowX = (bounds.width - thirdRowWidth) / 2
        createKeyRow(keys: thirdRow, yPosition: keySpacing + 2 * (keyHeight + rowSpacing), xOffset: thirdRowX)
    }
    
    private func createKeyRow(keys: [String], yPosition: CGFloat, xOffset: CGFloat = 0) {
        for (index, key) in keys.enumerated() {
            let button = createKeyButton(title: key, isProgrammerKey: false)
            let x = xOffset + CGFloat(index) * (keyHeight + keySpacing)
            button.frame = CGRect(x: x, y: yPosition, width: keyHeight, height: keyHeight)
            addSubview(button)
            keyButtons.append(button)
        }
    }
    
    private func createProgrammerKeys() {
        let startY = keySpacing + 3 * (keyHeight + rowSpacing)
        let keysPerRow = 10
        let totalRows = (programmerKeys.count + keysPerRow - 1) / keysPerRow
        
        for row in 0..<totalRows {
            let startIndex = row * keysPerRow
            let endIndex = min(startIndex + keysPerRow, programmerKeys.count)
            let rowKeys = Array(programmerKeys[startIndex..<endIndex])
            
            let rowWidth = CGFloat(rowKeys.count) * (keyHeight + keySpacing) - keySpacing
            let rowX = (bounds.width - rowWidth) / 2
            
            for (index, (key, color)) in rowKeys.enumerated() {
                let button = createKeyButton(title: key, isProgrammerKey: true, color: color)
                let x = rowX + CGFloat(index) * (keyHeight + keySpacing)
                let y = startY + CGFloat(row) * (keyHeight + rowSpacing)
                button.frame = CGRect(x: x, y: y, width: keyHeight, height: keyHeight)
                addSubview(button)
                programmerKeyButtons.append(button)
            }
        }
    }
    
    private func createFunctionKeys() {
        let functionRowY = keySpacing + (3 + (programmerKeys.count + 9) / 10) * (keyHeight + rowSpacing)
        
        // Next keyboard button (globe icon)
        let nextKeyboardButton = createFunctionButton(title: "🌐", action: #selector(nextKeyboardTapped))
        nextKeyboardButton.frame = CGRect(x: keySpacing, y: functionRowY, width: keyHeight, height: keyHeight)
        addSubview(nextKeyboardButton)
        
        // Space button
        let spaceButton = createFunctionButton(title: "space", action: #selector(spaceTapped))
        let spaceWidth = bounds.width - 4 * keyHeight - 4 * keySpacing
        spaceButton.frame = CGRect(x: 2 * keyHeight + 2 * keySpacing, y: functionRowY, width: spaceWidth, height: keyHeight)
        addSubview(spaceButton)
        
        // Backspace button
        let backspaceButton = createFunctionButton(title: "⌫", action: #selector(backspaceTapped))
        backspaceButton.frame = CGRect(x: bounds.width - 2 * keyHeight - keySpacing, y: functionRowY, width: keyHeight, height: keyHeight)
        addSubview(backspaceButton)
        
        // Return button
        let returnButton = createFunctionButton(title: "return", action: #selector(returnTapped))
        returnButton.frame = CGRect(x: bounds.width - keyHeight - keySpacing, y: functionRowY, width: keyHeight, height: keyHeight)
        addSubview(returnButton)
    }
    
    private func createKeyButton(title: String, isProgrammerKey: Bool, color: UIColor = UIColor.systemGray) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: isProgrammerKey ? 16 : 18, weight: .medium)
        button.backgroundColor = color
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 2
        
        if isProgrammerKey {
            button.addTarget(self, action: #selector(programmerKeyTapped(_:)), for: .touchUpInside)
        } else {
            button.addTarget(self, action: #selector(alphabetKeyTapped(_:)), for: .touchUpInside)
        }
        
        return button
    }
    
    private func createFunctionButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = UIColor.systemGray4
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 2
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    // MARK: - Button Actions
    @objc private func alphabetKeyTapped(_ sender: UIButton) {
        if let title = sender.title(for: .normal) {
            delegate?.keyTapped(title)
        }
        
        // Visual feedback
        animateButtonTap(sender)
    }
    
    @objc private func programmerKeyTapped(_ sender: UIButton) {
        if let title = sender.title(for: .normal) {
            delegate?.keyTapped(title)
        }
        
        // Visual feedback
        animateButtonTap(sender)
    }
    
    @objc private func backspaceTapped() {
        delegate?.backspaceTapped()
    }
    
    @objc private func spaceTapped() {
        delegate?.spaceTapped()
    }
    
    @objc private func returnTapped() {
        delegate?.returnTapped()
    }
    
    @objc private func nextKeyboardTapped() {
        delegate?.nextKeyboardTapped()
    }
    
    private func animateButtonTap(_ button: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            button.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                button.transform = CGAffineTransform.identity
            }
        }
    }
}
