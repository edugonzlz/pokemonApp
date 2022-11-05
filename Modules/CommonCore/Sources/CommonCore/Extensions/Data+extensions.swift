import Foundation

public extension Data {
    func toSet<T: Decodable>() -> Set<T>? {
        let decoder = JSONDecoder()
        return try? decoder.decode(Set<T>.self, from: self)
    }
}
