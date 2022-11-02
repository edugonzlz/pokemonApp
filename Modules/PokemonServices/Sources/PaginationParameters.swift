public struct PaginationParameters {
    public let offset: Int
    public let limit: Int
    
    public init(offset: Int, limit: Int) {
        self.offset = offset
        self.limit = limit
    }
}
