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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateKeyboardReadiness()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    private func setupKeyboardView() {
        keyboardView = KeyboardView(keyboardViewController: self)
        view.addSubview(keyboardView)
        keyboardView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            keyboardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keyboardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keyboardView.topAnchor.constraint(equalTo: view.topAnchor),
            keyboardView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            keyboardView.heightAnchor.constraint(equalToConstant: 280)
        ])
    }
    
    private func validateKeyboardReadiness() {
        // Minimal delay to ensure view is fully loaded
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [weak self] in
            self?.isKeyboardReady = true
            self?.keyboardView?.enableButtons()
        }
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
