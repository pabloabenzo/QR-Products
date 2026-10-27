import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift
import AuthenticationServices
import CryptoKit
import Observation

class LoginAuth: UIViewController, ASAuthorizationControllerDelegate {
    
    private var userTokenID: GIDToken?
    
    func signInWithGoogle() async -> Bool {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return false }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = await windowScene.windows.first?.rootViewController else { return false }
        
        do {
            let signInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            let user = signInResult.user
            guard let idToken = user.idToken?.tokenString else { return false }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            let result = try await Auth.auth().signIn(with: credential)
            print("User signed in: \(result.user.email ?? "No email")")
            return true
        } catch {
            print("Error signing in: \(error.localizedDescription)")
            return false
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    }
}
