import Foundation

final class API {
    func getPrice(code: String) async -> Double {
        do {
            guard let url = URL(string: "https://www.fundsexplorer.com.br/funds/\(code)") else {
                throw URLError(.badURL)
            }

            let (data, _) = try await URLSession.shared.data(from: url)

            guard let res = String(data: data, encoding: .utf8) else {
                throw URLError(.cannotParseResponse)
            }

            let regex = try NSRegularExpression(pattern: "<p>\\s*R\\$\\s*[0-9]+,[0-9]{2}\\s*</p>")

            guard let match = regex.firstMatch(
                in: res, options: [],
                range: NSRange(location: 0, length: res.count)
            ) else {
                return 0
            }

            guard let range = Range(match.range, in: res) else {
                return 0
            }

            let priceString = String(res[range])
                .replacingOccurrences(of: "<p>", with: "")
                .replacingOccurrences(of: "</p>", with: "")
                .replacingOccurrences(of: "R$", with: "")
                .trimmingCharacters(in: .whitespaces)
                .replacingOccurrences(of: ".", with: "")
                .replacingOccurrences(of: ",", with: ".")

            guard let price = Double(priceString) else {
                return 0
            }

            return price

        } catch {}

        return 0
    }
}
