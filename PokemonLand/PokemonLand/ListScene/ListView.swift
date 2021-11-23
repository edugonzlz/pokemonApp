import SwiftUI

struct ListView: View {

    @ObservedObject var viewModel: ListViewModel

    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                ScrollView {
                    LazyVGrid(columns: config(viewWidth: proxy.size.width),
                              spacing: Constants.margin) {
                        ForEach(viewModel.data, id: \.self) { item in
                            PokemonCell(vo: item)
                                .onAppear {
                                    self.viewModel.getPokemonDetail(name: item.name)
                                }
                        }
                    }.onAppear {
                        self.viewModel.getData()
                    }.padding(EdgeInsets(top: 0, leading: Constants.margin,
                                         bottom: 0, trailing: Constants.margin))
                }
                .navigationBarTitle("Pokemon Land (\(viewModel.data.count))")

            }
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
