import SwiftUI
import SwiftData

struct Home: View {
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
                ForEach(0..<10) { index in
                    NavigationLink(destination: Text("Item \(index)")) {
                        Text("Item \(index)")
                    }
                }
            }.navigationSplitViewColumnWidth(180)
                .toolbar {
                    ToolbarItem {
                        NavigationLink(
                            destination: Add()
                        ) {
                            Image(systemName: "plus.circle")
                        }
                    }
                }
        }
        detail: {
            Text("Selecione um Item")
        }.navigationTitle("Ativo Alvo")
    }
}

#Preview {
    Home()
}
