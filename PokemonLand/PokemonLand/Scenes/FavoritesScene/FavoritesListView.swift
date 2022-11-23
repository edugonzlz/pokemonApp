import SwiftUI

struct FavoritesListView<M: FavoritesListViewModelProtocol>: View {

    @StateObject var viewModel: M

    var body: some View {
        VerticalCardGrid {
            ForEach(viewModel.vo.items) { item in
                if let pokemon = viewModel.pokemons[item.id] {
                    NavigationLink(value: Route.detail(pokemon)) {
                        PokemonCell(vo: item)
                    }
                }
            }
        }
        .onAppear {
            self.viewModel.getData()

        }
        .navigationDestination(for: Route.self) { route in
            route.execute()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle("Favorites")
    }
}

// MARK: - Private
private extension FavoritesListView {
}
