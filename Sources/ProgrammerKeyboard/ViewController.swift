import UIKit

class ViewController: UIViewController {

    private var titleLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var setupButton: UIButton!
    private var settingsButton: UIButton!
    private var statusLabel: UILabel!
    private var keyboardStatusView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        checkKeyboardStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkKeyboardStatus()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground
        
        // Title
        titleLabel = UILabel()
        titleLabel.text = "Programmer Keyboard"
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        // Subtitle
        let subtitleLabel = UILabel()
        subtitleLabel.text = "Professional Coding on iOS"
        subtitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = UIColor.secondaryLabel
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subtitleLabel)
        
        // Description
        descriptionLabel = UILabel()
        descriptionLabel.text = "A custom keyboard designed for programmers with easy access to numbers, brackets, and operators on the same page as alphabets. Features Python-inspired color coding for intuitive symbol recognition."
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = UIColor.secondaryLabel
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        // Keyboard Status View
        keyboardStatusView = UIView()
        keyboardStatusView.backgroundColor = UIColor.systemGray6
        keyboardStatusView.layer.cornerRadius = 12
        keyboardStatusView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(keyboardStatusView)
        
        let statusTitleLabel = UILabel()
        statusTitleLabel.text = "Keyboard Status"
        statusTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        statusTitleLabel.textColor = UIColor.label
        statusTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        keyboardStatusView.addSubview(statusTitleLabel)
        
        statusLabel = UILabel()
        statusLabel.text = "Checking status..."
        statusLabel.font = UIFont.systemFont(ofSize: 16)
        statusLabel.textColor = UIColor.secondaryLabel
        statusLabel.numberOfLines = 0
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        keyboardStatusView.addSubview(statusLabel)
        
        // Setup Button
        setupButton = UIButton(type: .system)
        setupButton.setTitle("Setup Keyboard", for: .normal)
        setupButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        setupButton.backgroundColor = UIColor.systemBlue
        setupButton.setTitleColor(.white, for: .normal)
        setupButton.layer.cornerRadius = 12
        setupButton.translatesAutoresizingMaskIntoConstraints = false
        setupButton.addTarget(self, action: #selector(setupButtonTapped), for: .touchUpInside)
        view.addSubview(setupButton)
        
        // Settings Button
        settingsButton = UIButton(type: .system)
        settingsButton.setTitle("Keyboard Settings", for: .normal)
        settingsButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        settingsButton.backgroundColor = UIColor.systemGray5
        settingsButton.setTitleColor(.label, for: .normal)
        settingsButton.layer.cornerRadius = 10
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        view.addSubview(settingsButton)
        
        // Features Section
        let featuresView = createFeaturesView()
        view.addSubview(featuresView)
        
        // Constraints
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            keyboardStatusView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            keyboardStatusView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 30),
            keyboardStatusView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            keyboardStatusView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            keyboardStatusView.heightAnchor.constraint(equalToConstant: 80),
            
            statusTitleLabel.topAnchor.constraint(equalTo: keyboardStatusView.topAnchor, constant: 16),
            statusTitleLabel.leadingAnchor.constraint(equalTo: keyboardStatusView.leadingAnchor, constant: 16),
            statusTitleLabel.trailingAnchor.constraint(equalTo: keyboardStatusView.trailingAnchor, constant: -16),
            
            statusLabel.topAnchor.constraint(equalTo: statusTitleLabel.bottomAnchor, constant: 8),
            statusLabel.leadingAnchor.constraint(equalTo: keyboardStatusView.leadingAnchor, constant: 16),
            statusLabel.trailingAnchor.constraint(equalTo: keyboardStatusView.trailingAnchor, constant: -16),
            
            setupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            setupButton.topAnchor.constraint(equalTo: keyboardStatusView.bottomAnchor, constant: 30),
            setupButton.widthAnchor.constraint(equalToConstant: 200),
            setupButton.heightAnchor.constraint(equalToConstant: 50),
            
            settingsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            settingsButton.topAnchor.constraint(equalTo: setupButton.bottomAnchor, constant: 16),
            settingsButton.widthAnchor.constraint(equalToConstant: 180),
            settingsButton.heightAnchor.constraint(equalToConstant: 44),
            
            featuresView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            featuresView.topAnchor.constraint(equalTo: settingsButton.bottomAnchor, constant: 30),
            featuresView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            featuresView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func createFeaturesView() -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = "Key Features"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textColor = UIColor.label
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        let features = [
            "🎯 Single page layout - no switching needed",
            "🎨 Python-inspired color coding",
            "🔢 Numbers, operators, brackets all accessible",
            "📱 Standard iOS keyboard appearance",
            "⚡ Optimized for programming workflows"
        ]
        
        var previousLabel: UILabel?
        for (index, feature) in features.enumerated() {
            let featureLabel = UILabel()
            featureLabel.text = feature
            featureLabel.font = UIFont.systemFont(ofSize: 16)
            featureLabel.textColor = UIColor.secondaryLabel
            featureLabel.numberOfLines = 0
            featureLabel.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(featureLabel)
            
            if index == 0 {
                featureLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
            } else {
                featureLabel.topAnchor.constraint(equalTo: previousLabel!.bottomAnchor, constant: 12).isActive = true
            }
            
            featureLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
            featureLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
            
            previousLabel = featureLabel
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        
        return containerView
    }
    
    private func checkKeyboardStatus() {
        // Check if keyboard extension is available
        let keyboardAvailable = UIApplication.shared.canOpenURL(URL(string: "keyboard://")!)
        
        if keyboardAvailable {
            statusLabel.text = "✅ Keyboard extension is available"
            statusLabel.textColor = UIColor.systemGreen
            setupButton.setTitle("Setup Complete", for: .normal)
            setupButton.backgroundColor = UIColor.systemGreen
            setupButton.isEnabled = false
        } else {
            statusLabel.text = "⚠️ Keyboard extension needs setup"
            statusLabel.textColor = UIColor.systemOrange
            setupButton.setTitle("Setup Keyboard", for: .normal)
            setupButton.backgroundColor = UIColor.systemBlue
            setupButton.isEnabled = true
        }
    }
    
    @objc private func setupButtonTapped() {
        let alert = UIAlertController(
            title: "Setup Programmer Keyboard",
            message: "Follow these steps to enable your new keyboard:\n\n1️⃣ Go to Settings > General > Keyboard > Keyboards\n2️⃣ Tap 'Add New Keyboard'\n3️⃣ Select 'Programmer Keyboard'\n4️⃣ Tap on 'Programmer Keyboard' and enable 'Allow Full Access'\n5️⃣ Switch to the keyboard in any text field using the globe button (🌐)",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsUrl)
            }
        })
        
        alert.addAction(UIAlertAction(title: "Got It", style: .cancel))
        present(alert, animated: true)
    }
    
    @objc private func settingsButtonTapped() {
        let alert = UIAlertController(
            title: "Keyboard Settings",
            message: "Customize your Programmer Keyboard experience:",
            preferredStyle: .actionSheet
        )
        
        alert.addAction(UIAlertAction(title: "Keyboard Settings", style: .default) { _ in
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsUrl)
            }
        })
        
        alert.addAction(UIAlertAction(title: "About Programmer Keyboard", style: .default) { _ in
            self.showAboutInfo()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        // For iPad
        if let popover = alert.popoverPresentationController {
            popover.sourceView = settingsButton
            popover.sourceRect = settingsButton.bounds
        }
        
        present(alert, animated: true)
    }
    
    private func showAboutInfo() {
        let alert = UIAlertController(
            title: "About Programmer Keyboard",
            message: "Version 1.0\n\nA custom iOS keyboard designed specifically for programmers.\n\nFeatures:\n• Single page layout\n• Python-inspired color coding\n• All programming symbols accessible\n• Professional iOS appearance\n\nMade with ❤️ for the developer community",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
