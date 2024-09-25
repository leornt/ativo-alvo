import SwiftUI

struct Add: View {
    init(asset: ModelAsset? = nil) {
        isEdit = asset != nil
        self.asset = asset ?? ModelAsset(code: "", quantity: 0)
    }

    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext

    @State private var error: String = ""
    @State private var isEdit: Bool = false
    @State private var isError: Bool = false
    @State private var isLoading: Bool = false
    @State private var asset: ModelAsset
    @State private var step: Int = 1

    func add() async {
        if asset.code.isEmpty {
            error = "Código inválido"
            isError.toggle()
            return
        }
        if !isEdit {
            modelContext.insert(asset)
        }
        dismiss()
    }

    var body: some View {
        ZStack {
            VStack(spacing: 32) {
                Text(
                    isEdit
                        ? "Editando: \(asset.code)"
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
                    Stepper(
                        "Cotas: \(asset.quantity)",
                        value: $asset.quantity,
                        in: 0 ... Int.max,
                        step: step
                    )
                    Button("x\(step)") {
                        switch step {
                        case 1:
                            step = 10
                        case 10:
                            step = 100
                        default:
                            step = 1
                        }
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
