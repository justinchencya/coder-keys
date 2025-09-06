import UIKit

class KeyboardViewController: UIInputViewController {
    
    private var keyboardView: KeyboardView!
    private var isKeyboardReady = false
    private var isInitialized = false
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardView()
        isInitialized = true
        isKeyboardReady = true
        
        // Register for trait changes using modern iOS 17+ APIs
        registerForTraitChanges()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Only setup if not already initialized - prevents recreation during switching
        if !isInitialized {
            setupKeyboardView()
            isInitialized = true
            isKeyboardReady = true
        }
        // No additional state changes to prevent flashing
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Ensure keyboard is ready without triggering state changes
        if !isKeyboardReady && isInitialized {
            isKeyboardReady = true
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
        
        // Create keyboard view without forcing layout operations
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
        
        // Let the system handle layout naturally - no forced layout calls
    }
    
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Don't make any state changes - this prevents flashing during switching
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Only reset shift state, don't disable buttons or change ready state
        keyboardView?.resetShiftState()
    }
    
    // MARK: - Public Interface for Keyboard State
    
    func isReady() -> Bool {
        return isKeyboardReady
    }
    
    func forceReadinessValidation() {
        // Only reset if not initialized to prevent flashing
        if !isInitialized {
            isKeyboardReady = false
            setupKeyboardView()
            isInitialized = true
            isKeyboardReady = true
        }
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
            isInitialized = false
        }
    }
    
    // MARK: - Trait Collection Handling
    
    private func registerForTraitChanges() {
        if #available(iOS 17.0, *) {
            // Use modern trait change registration APIs
            registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: KeyboardViewController, previousTraitCollection: UITraitCollection) in
                // The KeyboardView will handle its own color updates via modern trait change APIs
                // No additional action needed here - the KeyboardView has its own trait change registration
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        // Only call super on iOS versions where it's not deprecated
        if #available(iOS 17.0, *) {
            // Don't call super on iOS 17+ as it's deprecated
        } else {
            super.traitCollectionDidChange(previousTraitCollection)
        }
        
        // If the keyboard view exists and the user interface style changed,
        // ensure it's properly updated (for iOS 16 and below)
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
