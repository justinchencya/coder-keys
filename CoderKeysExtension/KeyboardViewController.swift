import UIKit

class KeyboardViewController: UIInputViewController {
    
    private var keyboardView: KeyboardView!
    private var isKeyboardReady = false
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardView()
        // Mark keyboard as ready immediately after setup to prevent flashing
        validateKeyboardReadiness()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Only validate readiness if the keyboard view doesn't exist
        // This prevents unnecessary state changes during rapid switching
        if keyboardView == nil {
            setupKeyboardView()
            validateKeyboardReadiness()
        } else {
            // Just ensure buttons are enabled for existing view
            keyboardView?.enableButtons()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Ensure keyboard is ready when it appears
        if !isKeyboardReady {
            validateKeyboardReadiness()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // Let the system handle layout naturally - no forced updates
    }
    
    private func setupKeyboardView() {
        // Only create the keyboard view if it doesn't exist
        // This prevents the flashing caused by recreating the view
        guard keyboardView == nil else { return }
        
        // Ensure the view has the correct trait collection before creating the keyboard view
        // This prevents color flashing during initialization
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        keyboardView = KeyboardView(keyboardViewController: self)
        view.addSubview(keyboardView)
        keyboardView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set up constraints to fill the entire view
        NSLayoutConstraint.activate([
            keyboardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keyboardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keyboardView.topAnchor.constraint(equalTo: view.topAnchor),
            keyboardView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Ensure the keyboard view is properly laid out before it becomes visible
        keyboardView.setNeedsLayout()
        keyboardView.layoutIfNeeded()
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
        // Don't disable buttons or reset state - this causes flashing
        // The keyboard will be reused when switching back
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Only reset shift state, don't disable buttons
        keyboardView?.resetShiftState()
    }
    
    // MARK: - Public Interface for Keyboard State
    
    func isReady() -> Bool {
        return isKeyboardReady
    }
    
    func forceReadinessValidation() {
        isKeyboardReady = false
        validateKeyboardReadiness()
    }
    
    // MARK: - Memory Management
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Only recreate view if absolutely necessary due to memory pressure
        // This is a last resort to prevent memory issues
        if keyboardView != nil {
            keyboardView.removeFromSuperview()
            keyboardView = nil
            isKeyboardReady = false
        }
    }
    
    // MARK: - Trait Collection Handling
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        // If the keyboard view exists and the user interface style changed,
        // ensure it's properly updated
        if keyboardView != nil && traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
            // The KeyboardView will handle its own color updates via traitCollectionDidChange
            // No additional action needed here
        }
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
