import SwiftUI
import PokemonServices

struct ListViewStack: View {

    @EnvironmentObject var router: Router

    var body: some View {
        NavigationStack(path: $router.path) {
            ListView(viewModel: ListViewModel())
        }
        .environmentObject(router)
    }
}

struct FavoritesListViewStack: View {
    @EnvironmentObject var router: Router

    var body: some View {
        NavigationStack(path: $router.path) {
            FavoritesListView(viewModel: FavoritesListViewModel())
        }
    }
}
