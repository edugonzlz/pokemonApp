import Foundation

public extension Set {
    func convertToData() -> Data? {
        try? JSONSerialization.data(withJSONObject: Array(self), options: [])
    }
}
