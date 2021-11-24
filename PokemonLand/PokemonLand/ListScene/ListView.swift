import SwiftUI

struct ListView: View {
    
    @ObservedObject var viewModel: ListViewModel
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                LazyVGrid(columns: config(viewWidth: proxy.size.width),
                          spacing: Constants.margin) {
                    
                    ForEach(viewModel.vo) { item in
                        NavigationLink {
                            if let pokemon = viewModel.pokemons[item.name.lowercased()] {
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
                    ProgressView()
                }
            }
            .navigationBarTitle("Pokemon Land (\(viewModel.vo.count))")
        }
    }
}

private extension ListView {
    struct Constants {
        static let margin: CGFloat = 10
        static let cellHeight: CGFloat = 250
        static func cellWidth(viewWidth: CGFloat) -> CGFloat {
            return (viewWidth - margin * 3)/2
        }
    }
    
    func config(viewWidth: CGFloat) -> [GridItem] {
        return [GridItem(.adaptive(minimum: Constants.cellWidth(viewWidth: viewWidth)))]
    }
}
