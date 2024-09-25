import SwiftData
import SwiftUI

struct Home: View {
    @Environment(\.modelContext) var modelContext

    @Query(sort: \ModelAsset.code) var assets: [ModelAsset]

    @State private var showAdd = false

    var body: some View {
        NavigationSplitView {
            List {
                NavigationLink(destination: Wallet()) {
                    HStack {
                        Image(systemName: "wallet.bifold")
                        Text("Minha Carteira")
                    }
                }
                Divider()
                ForEach(assets) { asset in
                    NavigationLink(destination: Add(asset: asset)) {
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
            Text("Selecione um Item")
        }.navigationTitle("Ativo Alvo")
            .sheet(isPresented: $showAdd) { Add() }
    }
}

#Preview {
    Home()
}
