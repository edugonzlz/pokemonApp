import Foundation

public extension Data {
    func dataToSet<T>() -> Set<T>? {
      (try? JSONSerialization.jsonObject(with: self, options: [])) as? Set<T>
    }
}
