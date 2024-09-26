import Foundation
import SwiftData

@Model
final class ModelAsset: Identifiable {
    init(code: String, ideal: Double = 0, quantity: Int) {
        self.code = code
        self.ideal = ideal
        self.quantity = quantity
    }

    @Attribute(.unique) var code: String

    var ideal: Double
    var price: Double?
    var quantity: Int
}
