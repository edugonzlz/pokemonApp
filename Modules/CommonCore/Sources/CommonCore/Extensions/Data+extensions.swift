import Foundation

public extension Data {
    func dataToArray<T>() -> Array<T>? {
      (try? JSONSerialization.jsonObject(with: self, options: [])) as? Array<T>
    }
}
