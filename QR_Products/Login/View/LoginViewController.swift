//
//  LoginView.swift
//  QR_Products
//
//  Created by Pablo Benzo on 12/06/2025.
//

import UIKit
import SwiftUI
import KeychainSwift

class LoginViewController: UIViewController {
    
    var viewModel = APIViewModel()
    var loginAuth = LoginAuth()
    var productsUI = ProductsUI()
    
    let keychain = KeychainSwift(keyPrefix: "com.tuempresa.qrproducts")
    
    private let usuarioTextField = UITextField()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton(type: .system)
    private let googleButton = UIButton(type: .system)
    private let appleButton = UIButton(type: .system)
    private let forgotPasswordButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        preloadUsername()
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
        
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = productsUI.uiColorManager(color: "primary")
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 6
        loginButton.addTarget(self, action: #selector(loadAndNavigate), for: .touchUpInside)
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
            googleButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
            googleButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
            googleButton.contentHorizontalAlignment = .center
        }
        
        googleButton.addTarget(self, action: #selector(handleGoogleLogin), for: .touchUpInside)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            usuarioTextField,
            passwordTextField,
            loginButton,
            forgotPasswordButton,
            googleButton,
            appleButton,
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
    
    //Comprobacion de credenciales.
    @objc private func loadAndNavigate() {
        dismissKeyboard()
        
        guard isLoginValid() else {
            let alert = UIAlertController(title: "Error", message: "Incorrect user and password.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        keychain.set(usuarioTextField.text ?? "", forKey: "usuario")
        
        activityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.activityIndicator.stopAnimating()
            let countryVC = UIHostingController(rootView: HomeView())
            self.navigationController?.pushViewController(countryVC, animated: true)
        }
    }
    
    private func isLoginValid() -> Bool {
        return usuarioTextField.text == "pbenzo@apple.com"
            && passwordTextField.text == "safeCode123"
    }
    
     private func preloadUsername() {
         if let savedUser = keychain.get("usuario") {
             usuarioTextField.text = savedUser
        }
    }
    
    @objc private func handleGoogleLogin() {
        Task {
            do {
                try await loginAuth.signInWithGoogle()
                let countryVC = UIHostingController(rootView: HomeView())
                self.navigationController?.pushViewController(countryVC, animated: true)
            } catch {
                let alert = UIAlertController(title: "Error", message: "Error logging in with Google: \(error.localizedDescription)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        }
    }
}
