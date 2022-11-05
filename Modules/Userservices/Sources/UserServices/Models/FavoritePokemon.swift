import Foundation

public struct FavoritePokemon: Codable {
    public let id: Int
    public let timestamp: Date

    public init(id: Int, timestamp: Date) {
        self.id = id
        self.timestamp = timestamp
    }
}

extension FavoritePokemon: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
