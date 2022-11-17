import SwiftUI
import PokemonServices

struct ListViewStack: View {
    @State private var path: [Route] = []

    var body: some View {
        NavigationStack(path: $path) {
            ListView(viewModel: ListViewModel())
        }
    }
}

struct FavoritesListViewStack: View {
    @State private var path: [Route] = []

    var body: some View {
        NavigationStack(path: $path) {
            FavoritesListView(viewModel: FavoritesListViewModel())
        }
    }
}
