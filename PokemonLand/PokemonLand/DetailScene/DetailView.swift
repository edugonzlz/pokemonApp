import SwiftUI
import Kingfisher
import PokemonServices

struct DetailView: View {

    @ObservedObject var viewModel: DetailViewModel

    var body: some View {
        ScrollView {
            VStack {
                KFImage(viewModel.vo.imageUrl)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Divider()
                Spacer()
            }
        }
        .background(.red)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle(viewModel.vo.name)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(viewModel: DetailViewModel(data: pokemonMock))
    }
}

let pokemonMock = Pokemon(id: 0, name: "test", order: 0, weight: nil, height: nil, sprites: nil)
