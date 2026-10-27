import Foundation
import Observation

@Observable
final class CardViewModel {
    var cardNumber: String = ""
    var cvv: String = ""
    var expiration: String = ""
    var showError: Bool = false
    var paymentSuccess: Bool = false
    var navigateToHome: Bool = false
    var isPaymentValid: Bool = false

    func pay() {
        if isCardValid() {
            isPaymentValid = true
        } else {
            isPaymentValid = false
        }
    }

    private func isCardValid() -> Bool {
        cardNumber.replacingOccurrences(of: " ", with: "") == "1234234534564567"
        && expiration == "12/28"
        && cvv == "182"
    }
}
