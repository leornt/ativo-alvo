import SwiftData
import SwiftUI

struct Home: View {
    @Environment(\.modelContext) var modelContext

    @Query(sort: \ModelAsset.code) var assets: [ModelAsset]

    @State private var showAdd: Bool = false
    @State private var showWallet: Bool = false

    enum NavigationSelection: Hashable {
        case asset(ModelAsset)
        case wallet
    }

    @State private var selection: NavigationSelection?

    var body: some View {
        NavigationSplitView {
            List(selection: $selection) {
                NavigationLink(
                    value: NavigationSelection.wallet
                ) {
                    HStack {
                        Image(systemName: "wallet.bifold")
                        Text("Minha Carteira")
                    }
                }
                Divider()
                ForEach(assets) { asset in
                    NavigationLink(
                        value: NavigationSelection.asset(asset)
                    ) {
                        Text("\(asset.code)")
                    }
                }
            }.navigationSplitViewColumnWidth(180)
                .toolbar {
                    ToolbarItem {
                        Button {
                            showAdd.toggle()
                        } label: {
                            Image(systemName: "plus.circle")
                        }
                    }
                }
        } detail: {
            if let selection = selection {
                switch selection {
                case .asset(let asset):
                    Add(value: .constant(asset))
                case .wallet:
                    Wallet()
                }
            } else {
                Text("Selecione um item")
            }
        }
        .navigationTitle("Ativo Alvo")
        .sheet(isPresented: $showAdd) { Add() }
    }
}

#Preview {
    let mc = try! ModelContainer(
        for: ModelAsset.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )

    mc.mainContext.insert(ModelAsset(code: "MXRF11", quantity: 5))
    mc.mainContext.insert(ModelAsset(code: "TGAR11", quantity: 5))

    return Home()
        .modelContainer(mc)
}
