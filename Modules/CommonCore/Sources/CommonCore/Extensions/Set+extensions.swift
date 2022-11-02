import Foundation

public extension Set {
    func convertToData() -> Data? {
        try? JSONSerialization.data(withJSONObject: self, options: [])
    }
}
