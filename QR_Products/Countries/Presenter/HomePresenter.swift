import Foundation
import Observation

enum HomeAction {
    case navigateToA
    case navigateToB
}

@MainActor
@Observable
final class HomePresenter {
    var model = HomeModel()
    var router: HomeRouter?
    
    func action(_ action: HomeAction) async {
        switch action {
        case .navigateToA:
            model.isLoadingToA = true
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            model.isLoadingToA = false
            model.isNavigatingToA = true
        case .navigateToB:
            model.isLoadingToB = true
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            model.isLoadingToB = false
            model.isNavigatingToB = true
        }
    }
}
