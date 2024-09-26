import Charts
import SwiftData
import SwiftUI

struct AssetChart: View {
    init(wallet: Bool = false) {
        self.wallet = wallet
    }

    private var wallet: Bool

    @Environment(\.modelContext) var modelContext
    @Query(sort: \ModelAsset.code) var assets: [ModelAsset]

    func getCurrent(e: ModelAsset) -> Double {
        var total: Double = 0
        for asset in assets {
            total += Double(asset.quantity) * (asset.price ?? 0)
        }
        return Double(e.quantity) * (e.price ?? 0) * 100 / total
    }

    var body: some View {
        VStack {
            Chart(assets, id: \.id) { asset in
                SectorMark(
                    angle: .value("Code", wallet ? getCurrent(e: asset) : asset.ideal),
                    innerRadius: .ratio(0.6),
                    angularInset: 2
                )
                .cornerRadius(5)
                .foregroundStyle(by: .value("Code", asset.code))
            }
            .chartLegend(alignment: .center)
            .scaledToFit()
        }.frame(maxHeight: .infinity, alignment: .top)
    }
}
