struct CountriesModel {
    var products: [ProductModel] = []
    var productsPlatzi: [ProductModelPlatzi] = []
    var selectedProduct: ProductModel? = nil
    var selectedProductPlatzi: ProductModelPlatzi? = nil
    var showModal: Bool = false
    var scannedCode: String = ""
    var shouldNavigateToCard: Bool = false
    var showAlert: Bool = false
}
