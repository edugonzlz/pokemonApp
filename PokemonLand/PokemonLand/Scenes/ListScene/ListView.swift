import SwiftUI

struct ListView<M: ListViewModelProtocol>: View {
    
    @StateObject var viewModel: M
    
    var body: some View {
        VStack {
            VerticalCardGrid {
                ForEach(viewModel.vo.items) { item in
                    if let pokemon = viewModel.pokemons[item.id] {
                        NavigationLink(value: Route.detail(pokemon)) {
                            PokemonCell(vo: item)
                                .onAppear {
                                    self.viewModel.loadMoreRows(pokemonName: item.name)
                                }
                        }
                    }
                }
            }

            if viewModel.isLoading {
                Spacer(minLength: 20)
                ProgressView()
            }
        }
        .onAppear {
            self.viewModel.getData()
        }
        .navigationDestination(for: Route.self) { route in
            route.execute()
        }
        .searchable(text: $viewModel.searchText)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle("Pokemon Land (\(viewModel.vo.items.count) - \(viewModel.vo.totalItems))")
    }
}

// MARK: - Private
private extension ListView {
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
