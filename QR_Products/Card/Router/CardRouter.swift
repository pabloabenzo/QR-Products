import UIKit

@MainActor
final class CardRouter {
    weak var navigationController: UINavigationController?
    
    func showLoading() {
    }
    
    func hideLoading() {
    }
    
    func showHome() {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
}
