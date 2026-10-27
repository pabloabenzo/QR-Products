import Foundation
import Observation

enum CardAction {
    case pay
    case reset
}

@MainActor
@Observable
final class CardPresenter {
    var model = CardModel()
    var router: CardRouter?
    
    func action(_ action: CardAction) async {
        switch action {
        case .pay:
            if isCardValid() {
                model.isPaymentValid = true
                model.paymentSuccess = true
            } else {
                model.isPaymentValid = false
                model.showError = true
            }
        case .reset:
            model = CardModel()
        }
    }
    
    private func isCardValid() -> Bool {
        model.cardNumber.replacingOccurrences(of: " ", with: "") == "4200224420002244" &&
        model.expiration == "12/25" &&
        model.cvv == "182"
    }
}
