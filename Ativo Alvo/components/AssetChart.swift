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

    var body: some View {
        VStack {
            Chart(assets, id: \.id) { asset in
                SectorMark(
                    angle: .value("Code", wallet ? Double(asset.quantity) : asset.ideal),
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
