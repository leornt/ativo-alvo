import SwiftUI

struct Wallet: View {
    var body: some View {
        HStack {
            VStack {
                Text("Minha Carteira")
                AssetChart(wallet: true)
            }
            VStack {
                Text("Carteira Ideal")
                AssetChart()
            }
        }
    }
}
