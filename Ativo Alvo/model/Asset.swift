import Foundation
import SwiftData

@Model
final class ModelAsset: Identifiable {
    init(code: String, quantity: Int) {
        self.code = code
        self.quantity = quantity
    }

    @Attribute(.unique) var code: String
    var quantity: Int
    var price: Double?
}
