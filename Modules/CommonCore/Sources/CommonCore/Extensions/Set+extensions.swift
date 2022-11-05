import Foundation

public extension Set where Element: Encodable {
    func toData() -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }
}
