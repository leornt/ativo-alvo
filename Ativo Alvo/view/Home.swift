import SwiftData
import SwiftUI

struct Home: View {
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
                ForEach(0 ..< 10) { index in
                    NavigationLink(destination: Text("Item \(index)")) {
                        Text("Item \(index)")
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
        }
        detail: {
            Text("Selecione um Item")
        }.navigationTitle("Ativo Alvo")
        .sheet(isPresented: $showAdd) { Add() }
    }
}

#Preview {
    Home()
}
