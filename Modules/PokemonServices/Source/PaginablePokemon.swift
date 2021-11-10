public protocol PaginablePokemon {
    associatedtype Item: NamedApiResource
    
    var count: Int  { get }
    var next: String? { get }
    var previous: String? { get }
    var results: [Item] { get }
}

public protocol NamedApiResource {
    var name: String { get }
    var url: String { get }
}
