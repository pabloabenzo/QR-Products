import UIKit
import SwiftUI

class LoginViewController: UIViewController {
    
    var presenter: LoginPresenter?
    var router: LoginRouter?
    
    private let usuarioTextField = UITextField()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton(type: .system)
    private let googleButton = UIButton(type: .system)
    private let forgotPasswordButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private let productsUI = ProductsUI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPresenter()
        setupView()
        Task {
            await presenter?.action(.preloadUser)
            if let email = presenter?.model.userEmail {
                usuarioTextField.text = email
            }
        }
    }
    
    private func setupPresenter() {
        presenter = LoginPresenter()
        router = LoginRouter()
        router?.navigationController = navigationController
        presenter?.router = router
    }
    
    private func setupView() {
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = productsUI.uiColorManager(color: "secondary")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        let titleLabel = UILabel()
        titleLabel.text = "Welcome to QR PRODUCTS"
        titleLabel.font = UIFont(name: "Montserrat", size: 35)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        usuarioTextField.placeholder = "User"
        usuarioTextField.keyboardType = .emailAddress
        usuarioTextField.borderStyle = .roundedRect
        usuarioTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        usuarioTextField.addTarget(self, action: #selector(emailChanged), for: .editingChanged)
        
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        passwordTextField.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
        
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = productsUI.uiColorManager(color: "primary")
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 6
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        forgotPasswordButton.setTitle("Have you forgotten your password?", for: .normal)
        forgotPasswordButton.setTitleColor(productsUI.uiColorManager(color: "primary"), for: .normal)
        forgotPasswordButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        googleButton.setTitle("Login with Google", for: .normal)
        googleButton.setTitleColor(productsUI.uiColorManager(color: "primary"), for: .normal)
        googleButton.backgroundColor = productsUI.uiColorManager(color: "base_white")
        googleButton.layer.cornerRadius = 6
        googleButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        if let googleIcon = UIImage(named: "google_icon") {
            googleButton.setImage(googleIcon, for: .normal)
            googleButton.imageView?.contentMode = .scaleAspectFit
            var configuration = UIButton.Configuration.plain()
            configuration.image = googleIcon
            configuration.title = "Login with Google"
            configuration.imagePadding = 10
            configuration.baseForegroundColor = productsUI.uiColorManager(color: "primary")
            googleButton.configuration = configuration
            googleButton.contentHorizontalAlignment = .center
        } else {
            googleButton.setTitle("Login with Google", for: .normal)
        }
        
        googleButton.addTarget(self, action: #selector(googleTapped), for: .touchUpInside)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            usuarioTextField,
            passwordTextField,
            loginButton,
            forgotPasswordButton,
            googleButton,
            activityIndicator
        ])
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func emailChanged() {
        presenter?.model.userEmail = usuarioTextField.text ?? ""
    }
    
    @objc private func passwordChanged() {
        presenter?.model.password = passwordTextField.text ?? ""
    }
    
    @objc private func loginTapped() {
        dismissKeyboard()
        Task {
            await presenter?.action(.login)
            if !(presenter?.model.isLoginValid ?? false) {
                let alert = UIAlertController(title: "Error", message: "Incorrect user and password.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
            }
        }
    }
    
    @objc private func googleTapped() {
        Task {
            await presenter?.action(.googleLogin)
        }
    }
}
