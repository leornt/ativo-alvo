import Foundation

final class API {
    func getPrice(code: String) async -> String {
        var price = ""

        do {
            guard let url = URL(string: "https://www.fundsexplorer.com.br/funds/\(code)") else {
                throw URLError(.badURL)
            }

            let (data, _) = try await URLSession.shared.data(from: url)

            guard let res = String(data: data, encoding: .utf8) else {
                throw URLError(.cannotParseResponse)
            }

            price = res
        } catch {}

        return price
    }
}
