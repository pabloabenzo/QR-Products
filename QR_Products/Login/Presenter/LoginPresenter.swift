import Foundation
import Observation
import KeychainSwift

enum LoginAction {
    case login
    case googleLogin
    case preloadUser
}

@MainActor
@Observable
final class LoginPresenter {
    var model = LoginModel()
    var router: LoginRouter?
    private let keychain = KeychainSwift(keyPrefix: "com.tuempresa.qrproducts")
    private let loginAuth = LoginAuth()
    
    func action(_ action: LoginAction) async {
        switch action {
        case .preloadUser:
            if let savedUser = keychain.get("usuario") {
                model.userEmail = savedUser
            }
        case .login:
            if model.userEmail == "pbenzo@apple.com" && model.password == "safeCode123" {
                model.isLoginValid = true
                keychain.set(model.userEmail, forKey: "usuario")
                router?.showHome()
            }
        case .googleLogin:
            let _ = await loginAuth.signInWithGoogle()
            router?.showHome()
        }
    }
}
