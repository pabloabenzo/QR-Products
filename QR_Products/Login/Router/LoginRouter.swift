import UIKit
import SwiftUI

@MainActor
final class LoginRouter {
    weak var navigationController: UINavigationController?
    
    func showLoading() {
        // Loading management
    }
    
    func hideLoading() {
        // Loading management
    }
    
    func showHome() {
        let presenter = HomePresenter()
        let router = HomeRouter()
        router.navigationController = navigationController
        presenter.router = router
        let view = HomeView(presenter: presenter)
        let hosting = UIHostingController(rootView: view)
        navigationController?.pushViewController(hosting, animated: true)
    }
}
