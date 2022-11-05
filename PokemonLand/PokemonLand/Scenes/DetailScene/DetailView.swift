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
                    .frame(height: 300)
                    .shadow(color: .cyan, radius: 20)
                Divider()
                Spacer()
            }
        }
        .onAppear {
            viewModel.getData()
        }
        .background(.red)
        .navigationBarTitle(viewModel.vo.name)
        .navigationBarTitleDisplayMode(.large)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(viewModel: DetailViewModel(data: pokemonMock))
    }
}
