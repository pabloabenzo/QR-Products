//
//  CardViewModel.swift
//  QR_Products
//
//  Created by Pablo Benzo on 15/06/2025.
//

import Foundation
import Observation
import Combine

@Observable
class CardViewModel: ObservableObject {
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
        cardNumber.replacingOccurrences(of: " ", with: "") == "4200224420002244"
        && cvv == "182"
        && expiration == "12/25"
    }
}
