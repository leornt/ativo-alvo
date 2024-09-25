import SwiftData
import SwiftUI

@main
struct Ativo_AlvoApp: App {
    var body: some Scene {
        WindowGroup {
            Home()
        }
        .modelContainer(for: ModelAsset.self)
    }
}
