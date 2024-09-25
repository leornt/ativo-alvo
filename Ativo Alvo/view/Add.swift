import SwiftUI

struct Add: View {
    init(asset: ModelAsset? = nil) {
        isEdit = asset != nil
        self.asset = asset ?? ModelAsset(code: "", quantity: 0)
    }

    @State
    private var isEdit: Bool = false
    @State
    private var isLoading: Bool = false
    @State
    private var asset: ModelAsset
    @State
    private var step: Int = 1

    @Environment(\.dismiss) var dismiss

    func add() async {
        sleep(5)
//        dismiss()
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
                HStack {
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
                }.frame(maxWidth: .infinity, alignment: .trailing)
            }
            .opacity(isLoading ? 0.1 : 1)
            .padding(.all, 32)
            if isLoading {
                ProgressView()
            }
        }
    }
}

#Preview {
    Add()
}
