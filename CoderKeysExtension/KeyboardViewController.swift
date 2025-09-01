import UIKit

class KeyboardViewController: UIInputViewController {
    
    private var keyboardView: KeyboardView!
    private var isKeyboardReady = false
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardView()
        // Mark keyboard as ready immediately after setup to prevent flashing
        validateKeyboardReadiness()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Ensure the view is properly laid out before appearing
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        // Re-validate readiness in case of rapid switching
        if !isKeyboardReady {
            validateKeyboardReadiness()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Keyboard is already ready from viewDidLoad, no need to validate again
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // Ensure consistent layout during subview updates
        if isKeyboardReady {
            keyboardView?.setNeedsLayout()
        }
    }
    
    private func setupKeyboardView() {
        // Remove existing keyboard view if it exists (prevents memory issues during switching)
        keyboardView?.removeFromSuperview()
        
        keyboardView = KeyboardView(keyboardViewController: self)
        view.addSubview(keyboardView)
        keyboardView.translatesAutoresizingMaskIntoConstraints = false
        
        // Remove the fixed height constraint to prevent layout conflicts
        // Let the view size itself based on content and system requirements
        NSLayoutConstraint.activate([
            keyboardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keyboardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keyboardView.topAnchor.constraint(equalTo: view.topAnchor),
            keyboardView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func validateKeyboardReadiness() {
        // Mark as ready immediately to prevent flashing
        // The view is already properly set up in viewDidLoad
        isKeyboardReady = true
        keyboardView?.enableButtons()
    }
    
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardView.disableButtons()
        isKeyboardReady = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Ensure complete cleanup when keyboard disappears
        keyboardView.resetShiftState()
    }
    
    // MARK: - Public Interface for Keyboard State
    
    func isReady() -> Bool {
        return isKeyboardReady
    }
    
    func forceReadinessValidation() {
        isKeyboardReady = false
        validateKeyboardReadiness()
    }
}

// MARK: - KeyboardViewDelegate
extension KeyboardViewController: KeyboardViewDelegate {
    func insertText(_ text: String) {
        guard isKeyboardReady else { return }
        textDocumentProxy.insertText(text)
    }
    
    func deleteBackward() {
        guard isKeyboardReady else { return }
        textDocumentProxy.deleteBackward()
    }
    
    func insertReturn() {
        guard isKeyboardReady else { return }
        textDocumentProxy.insertText("\n")
    }
    
    func switchToNextInputMode() {
        super.advanceToNextInputMode()
    }
}
