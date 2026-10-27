import UIKit
import SwiftUI

@MainActor
final class HomeRouter {
    weak var navigationController: UINavigationController?
    
    func showLoading() {
        // Loading management
    }
    
    func hideLoading() {
        // Loading management
    }
    
    func showPaisA() {
        let presenter = CountriesPresenter()
        let view = PaisAView(presenter: presenter)
        let hosting = UIHostingController(rootView: view)
        navigationController?.pushViewController(hosting, animated: true)
    }
    
    func showPaisB() {
        let presenter = CountriesPresenter()
        let view = PaisBView(presenter: presenter)
        let hosting = UIHostingController(rootView: view)
        navigationController?.pushViewController(hosting, animated: true)
    }
}
