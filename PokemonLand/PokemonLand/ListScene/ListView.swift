import SwiftUI

struct ListView: View {

    @ObservedObject var viewModel: ListViewModel

    var body: some View {
        NavigationView {
            List(viewModel.data) { item in
                PokemonRow(vo: item)
            }
            .navigationBarTitle(Text("Pokemon Land (\(viewModel.data.count))"))
            .onAppear {
                self.viewModel.getData()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(viewModel: ListViewModel())
    }
}
