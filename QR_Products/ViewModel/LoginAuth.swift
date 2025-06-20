//
//  LoginAuth.swift
//  QR_Products
//
//  Created by Pablo Benzo on 12/06/2025.
//

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

class LoginAuth: UIViewController, ObservableObject, ASAuthorizationControllerDelegate {
    
    private var userTokenID: GIDToken?
    
    // MARK: - Google SignIn
    
    func signInWithGoogle() async -> Bool {
        
        let clientID = "981676086244-4ojnh5sr6pmqshqob0jmqi8edq1h8q75.apps.googleusercontent.com"
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = await windowScene.windows.first,
              let rootViewController = await window.rootViewController else {
            print("No hay root view controller")
            return false
        }
        
        do {
            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            let user = userAuthentication.user
            guard let idToken = user.idToken else {
                throw AuthenticationError.missingCredential
            }
            let accessToken = user.accessToken
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            let result = try await Auth.auth().signIn(with: credential)
            let firebaseUser = result.user
            self.userTokenID = accessToken
            
            print("Usuario \(firebaseUser.displayName) logueado con el correo \(firebaseUser.email ?? "unknow")")
            postSignInWithGoogle()
            return true
        }
        catch {
            print(error.localizedDescription)
            let errorMessage = error.localizedDescription
            return false
        }
    }
    
    func postSignInWithGoogle() {
        
        let url = "https://api.qrproducts.com/api/auth-mobile/google/login"
        var serializer = DataResponseSerializer(emptyResponseCodes: Set([200, 400, 500]))
        
        var userDataRequest = URLRequest(url: URL(string: url)!)
        userDataRequest.httpMethod = HTTPMethod.post.rawValue
        
        AF.upload(multipartFormData: { multipartFormData in
            
            multipartFormData.append(Data((self.userTokenID?.tokenString.utf8)!), withName: self.userTokenID?.tokenString ?? "")
            
        }, to: url, method: .post)
        
        .uploadProgress { progress in
            
            print(CGFloat(progress.fractionCompleted))
            
        }
        
        .response { response in
            
            if (response.error == nil) {
                
                do {
                    let json = try JSON(data: response.data!)
                    print("Parsed JSON: \(json)")
                    
                } catch {
                    print("Failed to parse JSON: \(error)")
                }
            }
        }
    }
}
