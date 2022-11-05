import PokemonServices

extension Pokemon: Reorderable {
    typealias OrderElement = Int
    var orderElement: OrderElement { id }
}
