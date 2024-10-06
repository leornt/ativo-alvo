import SwiftData
import SwiftUI

struct Add: View {
    init(value: Binding<ModelAsset>? = nil) {
        isEdit = value != nil
        _asset = value ?? .constant(ModelAsset(code: "", quantity: 0))
    }

    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @Query(sort: \ModelAsset.code) var assets: [ModelAsset]

    @Binding private var asset: ModelAsset
    @State private var error: String = ""
    @State private var isEdit: Bool = false
    @State private var isError: Bool = false
    @State private var isLoading: Bool = false

    func add() async {
        if asset.code.isEmpty {
            error = "Código inválido"
            isError.toggle()
            return
        }

        let price = await API().getPrice(code: asset.code)
        if price == 0 {
            error = "Preço não encontrado"
            isError.toggle()
            return
        }
        asset.price = price
        asset.lastUpdate = Date.now

        if !isEdit {
            modelContext.insert(asset)
        }
        dismiss()
    }

    func getRemaining() -> Double {
        var remaining: Double = 100
        for asset in assets {
            if asset.code == self.asset.code {
                continue
            }
            remaining -= asset.ideal
        }
        return remaining
    }

    var body: some View {
        ZStack {
            VStack(spacing: 32) {
                HStack(spacing: 32) {
                    VStack(spacing: 32) {
                        Text(
                            isEdit
                                ? "\(asset.code) (R$ \(asset.priceF()))"
                                : "Qual ativo deseja adicionar? (ex: MXRF11)"
                        )
                        TextField(
                            "_ _ _ _ _ _ _",
                            text: $asset.code
                        )
                        .frame(width: 85)
                        .onChange(of: asset.code) {
                            asset.code = asset.code.uppercased()
                            if asset.code.count > 7 {
                                asset.code = String(asset.code.prefix(7))
                            }
                        }
                        HStack {
                            Slider(
                                value: $asset.ideal,
                                in: 0 ... getRemaining()
                            )
                            TextField(
                                "",
                                text: Binding(
                                    get: { String(format: "%.2f", asset.ideal) },
                                    set: { asset.ideal = Double($0) ?? 0 }
                                )
                            )
                            .frame(width: 60)
                            .multilineTextAlignment(.trailing)
                            .onChange(of: asset.ideal) {
                                if asset.ideal > getRemaining() {
                                    asset.ideal = getRemaining()
                                }
                            }
                            Text("%")
                        }
                    }
                    if isEdit {
                        AssetChart()
                    }
                }
                if asset.ideal == 0 {
                    Toggle(isOn: $asset.isIgnored) {
                        Text("Ignorar ativo? (Fora da carteira recomendada)")
                    }
                }
                HStack(spacing: 16) {
                    if !isEdit {
                        Button("Cancelar") {
                            dismiss()
                        }
                        Button("Adicionar") {
                            isLoading = true
                            Task {
                                await add()
                                isLoading = false
                            }
                        }.buttonStyle(.borderedProminent)
                    } else {
                        Button("Excluir", role: .destructive) {
                            modelContext.delete(asset)
                            dismiss()
                        }
                        .buttonStyle(.borderless)
                        .tint(.red)
                    }
                }.frame(maxWidth: .infinity, alignment: .trailing)
            }
            .opacity(isLoading ? 0.1 : 1)
            .padding(.all, 32)
            if isLoading {
                ProgressView()
            }
        }.alert(isPresented: $isError) {
            Alert(
                title: Text("Oops!!"),
                message: Text(error),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    Add()
}
