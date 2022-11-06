import SwiftUI

struct FavoritesListView<M: FavoritesListViewModelProtocol>: View {

    @StateObject var viewModel: M

    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                LazyVGrid(columns: config(viewWidth: proxy.size.width),
                          spacing: Constants.margin) {

                    ForEach(viewModel.vo.items) { item in
                        NavigationLink {
                            if let pokemon = viewModel.pokemons[item.id] {
                                DetailView(viewModel: DetailViewModel(data: pokemon)) }
                        }
                    label: { PokemonCell(vo: item) }
                    }

                }.onAppear {
                    self.viewModel.getData()

                }.padding(EdgeInsets(top: 0, leading: Constants.margin,
                                     bottom: 0, trailing: Constants.margin))
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("Favorites")
        }
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
