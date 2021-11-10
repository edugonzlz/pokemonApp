extension Encodable {
    var data: Data? {
        return try? JSONEncoder().encode(self)
    }
}
