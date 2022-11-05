import SwiftUI

struct ListView<M: ListViewModelProtocol>: View {
    
    @ObservedObject var viewModel: M
    
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
                    label: {
                        PokemonCell(vo: item)
                            .onAppear {
                                self.viewModel.loadMoreRows(pokemonName: item.name)
                            }}
                    }
                    
                }.onAppear {
                    self.viewModel.getData()
                    
                }.padding(EdgeInsets(top: 0, leading: Constants.margin,
                                     bottom: 0, trailing: Constants.margin))
                
                if viewModel.isLoading {
                    Spacer(minLength: 20)
                    ProgressView()
                }
            }
            .searchable(text: Binding(get: {
                viewModel.searchText
            }, set: { value in
                viewModel.listen(searchText: value)
            }))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("Pokemon Land (\(viewModel.vo.items.count) - \(viewModel.vo.totalItems))")
        }
    }
}

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
