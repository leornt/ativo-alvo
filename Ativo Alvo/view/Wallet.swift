import SwiftData
import SwiftUI

struct Wallet: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \ModelAsset.code) var assets: [ModelAsset]

    func getTotal(ignored: Bool = false) -> Double {
        var total: Double = 0
        for asset in assets {
            if !ignored && asset.isIgnored { continue }
            total += (asset.price ?? 0) * Double(asset.quantity)
        }
        return total
    }

    func idealQnt(asset: ModelAsset) -> Int {
        return Int((getTotal() * asset.ideal / 100 / (asset.price ?? 0)).rounded())
    }

    func rec(asset: ModelAsset) -> String {
        if asset.isIgnored { return "-" }
        let cIdeal = idealQnt(asset: asset)
        if cIdeal == asset.quantity { return "-" }

        var cRec = ""
        cRec += (cIdeal > asset.quantity ? "C" : "V")
        cRec += " -> "
        cRec += (cIdeal - asset.quantity)
            .magnitude
            .description
        return cRec
    }

    var body: some View {
        VStack(spacing: 16) {
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
            List {
                HStack {
                    Text("Ativo")
                    Spacer()
                    Text("Recomendação")
                    Spacer()
                    Text("Quantidade (editável)")
                }
                ForEach(assets) { asset in
                    HStack {
                        Text("\(asset.code)")
                        Spacer()
                        Text(rec(asset: asset))
                        Spacer()
                        TextField(
                            "",
                            text: Binding(
                                get: {
                                    String(format: "%d", asset.quantity)
                                },
                                set: { asset.quantity = Int($0) ?? 0 }
                            )
                        )
                        .frame(width: 60)
                        .multilineTextAlignment(.trailing)
                    }
                }
            }
        }
    }
}

#Preview {
    let mc = try! ModelContainer(
        for: ModelAsset.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )

    mc.mainContext.insert(ModelAsset(code: "MXRF11", quantity: 5))
    mc.mainContext.insert(ModelAsset(code: "TGAR11", quantity: 5))

    return Wallet()
        .modelContainer(mc)
}
