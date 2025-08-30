import UIKit

class KeyboardViewController: UIInputViewController {
    
    private var keyboardView: KeyboardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardView.frame = view.bounds
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        keyboardView.frame = view.bounds
    }
    
    private func setupKeyboard() {
        keyboardView = KeyboardView()
        keyboardView.delegate = self
        view.addSubview(keyboardView)
        
        // Set constraints
        keyboardView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            keyboardView.topAnchor.constraint(equalTo: view.topAnchor),
            keyboardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keyboardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keyboardView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - KeyboardViewDelegate
extension KeyboardViewController: KeyboardViewDelegate {
    func keyTapped(_ key: String) {
        textDocumentProxy.insertText(key)
    }
    
    func backspaceTapped() {
        textDocumentProxy.deleteBackward()
    }
    
    func spaceTapped() {
        textDocumentProxy.insertText(" ")
    }
    
    func returnTapped() {
        textDocumentProxy.insertText("\n")
    }
    
    func nextKeyboardTapped() {
        advanceToNextInputMode()
    }
}
