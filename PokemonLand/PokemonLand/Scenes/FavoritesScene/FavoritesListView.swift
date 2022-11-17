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
            switch route {
            case .detail(let pokemon):
                DetailView(viewModel: DetailViewModel(data: pokemon))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle("Favorites")
    }
}

// MARK: - Private
private extension FavoritesListView {
    struct Constants {
        static var margin: CGFloat {
            10
        }
        static var cellHeight: CGFloat {
            250
        }
        static func cellWidth(viewWidth: CGFloat) -> CGFloat {
            return (viewWidth - margin * 3)/2
        }
    }

    func config(viewWidth: CGFloat) -> [GridItem] {
        return [GridItem(.adaptive(minimum: Constants.cellWidth(viewWidth: viewWidth)))]
    }
}
