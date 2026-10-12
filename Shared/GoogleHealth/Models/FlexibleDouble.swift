import Foundation

/// Google encodes 64-bit integers as JSON strings and everything else as numbers.
struct FlexibleDouble: Decodable {
    let value: Double

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let number = try? container.decode(Double.self) {
            value = number
            return
        }
        let text = try container.decode(String.self)
        guard let number = Double(text) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Expected a number, got \(text)")
        }
        value = number
    }
}
