import UIKit

class KeyboardViewController: UIInputViewController {
    
    private var keyboardView: KeyboardView!
    private var isKeyboardReady = false
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
    }
    
    override func viewDidLoad() {
        print("[KeyboardViewController] viewDidLoad called")
        super.viewDidLoad()
        setupKeyboardView()
        print("[KeyboardViewController] viewDidLoad completed")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("[KeyboardViewController] viewWillAppear called")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("[KeyboardViewController] viewDidAppear called")
        validateKeyboardReadiness()
    }
    
    override func viewWillLayoutSubviews() {
        keyboardView.sizeToFit()
        super.viewWillLayoutSubviews()
    }
    
    private func setupKeyboardView() {
        print("[KeyboardViewController] Creating KeyboardView...")
        keyboardView = KeyboardView(keyboardViewController: self)
        print("[KeyboardViewController] Adding KeyboardView to view hierarchy...")
        view.addSubview(keyboardView)
        keyboardView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            keyboardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keyboardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keyboardView.topAnchor.constraint(equalTo: view.topAnchor),
            keyboardView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        print("[KeyboardViewController] KeyboardView setup completed")
    }
    
    private func validateKeyboardReadiness() {
        print("[KeyboardViewController] Validating keyboard readiness...")
        
        // Check if textDocumentProxy is available and ready
        guard textDocumentProxy != nil else {
            print("[KeyboardViewController] ❌ textDocumentProxy is nil")
            isKeyboardReady = false
            // Retry after a short delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.validateKeyboardReadiness()
            }
            return
        }
        
        // Check if the keyboard view delegate is properly connected
        guard keyboardView.delegate != nil else {
            print("[KeyboardViewController] ❌ KeyboardView delegate is nil")
            isKeyboardReady = false
            // Retry after a short delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.validateKeyboardReadiness()
            }
            return
        }
        
        // Test if we can actually insert text
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.performReadinessTest()
        }
    }
    
    private func performReadinessTest() {
        print("[KeyboardViewController] Performing readiness test...")
        
        // Try to insert a test character to verify the keyboard is working
        let testChar = "a"
        textDocumentProxy.insertText(testChar)
        
        // Check if the text was actually inserted
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [weak self] in
            if self?.textDocumentProxy.hasText == true {
                // Remove the test character
                self?.textDocumentProxy.deleteBackward()
                self?.isKeyboardReady = true
                print("[KeyboardViewController] ✅ Keyboard is ready and working")
                
                // Enable all buttons now that keyboard is ready
                DispatchQueue.main.async {
                    self?.keyboardView.enableButtons()
                }
            } else {
                self?.isKeyboardReady = false
                print("[KeyboardViewController] ❌ Keyboard readiness test failed")
                
                // Keep buttons disabled if test failed
                DispatchQueue.main.async {
                    self?.keyboardView.disableButtons()
                }
                
                // Retry the test after a delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                    if self?.isKeyboardReady == false {
                        print("[KeyboardViewController] 🔄 Retrying readiness test...")
                        self?.performReadinessTest()
                    }
                }
            }
        }
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
        print("[KeyboardViewController] textWillChange called")
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        print("[KeyboardViewController] textDidChange called")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("[KeyboardViewController] viewWillDisappear called")
        // Disable buttons when keyboard is disappearing
        keyboardView.disableButtons()
        isKeyboardReady = false
    }
    
    // MARK: - Public Interface for Keyboard State
    
    func isReady() -> Bool {
        return isKeyboardReady && textDocumentProxy != nil
    }
    
    func forceReadinessValidation() {
        print("[KeyboardViewController] 🔄 Force triggering readiness validation...")
        isKeyboardReady = false
        validateKeyboardReadiness()
    }
}

// MARK: - KeyboardViewDelegate
extension KeyboardViewController: KeyboardViewDelegate {
    func insertText(_ text: String) {
        print("[KeyboardViewController] insertText called with: '\(text)'")
        
        // Validate keyboard readiness before proceeding
        guard isKeyboardReady else {
            print("[KeyboardViewController] ❌ Keyboard not ready, cannot insert text")
            return
        }
        
        guard textDocumentProxy != nil else {
            print("[KeyboardViewController] ❌ textDocumentProxy is nil")
            return
        }
        
        print("[KeyboardViewController] textDocumentProxy exists: \(textDocumentProxy)")
        print("[KeyboardViewController] textDocumentProxy hasText: \(textDocumentProxy.hasText)")
        
        // Perform the text insertion
        textDocumentProxy.insertText(text)
        print("[KeyboardViewController] insertText completed")
    }
    
    func deleteBackward() {
        print("[KeyboardViewController] deleteBackward called")
        
        // Validate keyboard readiness before proceeding
        guard isKeyboardReady else {
            print("[KeyboardViewController] ❌ Keyboard not ready, cannot delete")
            return
        }
        
        guard textDocumentProxy != nil else {
            print("[KeyboardViewController] ❌ textDocumentProxy is nil")
            return
        }
        
        textDocumentProxy.deleteBackward()
        print("[KeyboardViewController] deleteBackward completed")
    }
    
    func insertReturn() {
        print("[KeyboardViewController] insertReturn called")
        
        // Validate keyboard readiness before proceeding
        guard isKeyboardReady else {
            print("[KeyboardViewController] ❌ Keyboard not ready, cannot insert return")
            return
        }
        
        guard textDocumentProxy != nil else {
            print("[KeyboardViewController] ❌ textDocumentProxy is nil")
            return
        }
        
        print("[KeyboardViewController] textDocumentProxy exists: \(textDocumentProxy)")
        textDocumentProxy.insertText("\n")
        print("[KeyboardViewController] insertReturn completed")
    }
    
    func switchToNextInputMode() {
        print("[KeyboardViewController] switchToNextInputMode called")
        super.advanceToNextInputMode()
    }
}
