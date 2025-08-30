import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var setupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground
        
        titleLabel = UILabel()
        titleLabel.text = "Programmer Keyboard"
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        descriptionLabel = UILabel()
        descriptionLabel.text = "A custom keyboard designed for programmers with easy access to numbers, brackets, and operators on the same page as alphabets."
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        setupButton = UIButton(type: .system)
        setupButton.setTitle("Setup Keyboard", for: .normal)
        setupButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        setupButton.backgroundColor = UIColor.systemBlue
        setupButton.setTitleColor(.white, for: .normal)
        setupButton.layer.cornerRadius = 12
        setupButton.translatesAutoresizingMaskIntoConstraints = false
        setupButton.addTarget(self, action: #selector(setupButtonTapped), for: .touchUpInside)
        view.addSubview(setupButton)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            setupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            setupButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 60),
            setupButton.widthAnchor.constraint(equalToConstant: 200),
            setupButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func setupButtonTapped() {
        let alert = UIAlertController(
            title: "Setup Instructions",
            message: "1. Go to Settings > General > Keyboard > Keyboards\n2. Tap 'Add New Keyboard'\n3. Select 'Programmer Keyboard'\n4. Tap on 'Programmer Keyboard' and enable 'Allow Full Access'\n5. Switch to the keyboard in any text field",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
