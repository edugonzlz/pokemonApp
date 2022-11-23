import SwiftUI
import Kingfisher

struct DetailView: View {

    @EnvironmentObject var router: Router
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

                Button("Pop to root") {
                    router.popToRoot()
                }
                .buttonStyle(.bordered)
                Spacer()
            }
        }
        .onAppear {
            viewModel.getData()
        }
        .background(.red)
        .navigationBarTitle(viewModel.vo.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar(.hidden, for: .tabBar)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(viewModel: DetailViewModel(data: pokemonMock))
    }
}
