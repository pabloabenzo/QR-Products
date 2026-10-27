import Foundation
import Observation

enum QRAction {
    case showScanner
    case scanCode(String)
    case dismiss
}

@MainActor
@Observable
final class QRPresenter {
    var model = QRModel()
    
    func action(_ action: QRAction) async {
        switch action {
        case .showScanner:
            model.isScannerVisible = true
        case .scanCode(let code):
            model.scannedCode = code
        case .dismiss:
            model.isScannerVisible = false
        }
    }
}
