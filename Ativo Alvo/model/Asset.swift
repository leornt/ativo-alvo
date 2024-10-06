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
    var isIgnored: Bool = false
    var lastUpdate: Date?
    var price: Double?
    var quantity: Int

    func priceF() -> String {
        if price == nil {
            return "-"
        }
        return String(format: "%.2f", price!)
            .replacingOccurrences(of: ",", with: "")
            .replacingOccurrences(of: ".", with: ",")
    }
}
