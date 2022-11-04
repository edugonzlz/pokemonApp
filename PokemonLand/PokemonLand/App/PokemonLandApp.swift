import SwiftUI

@main
struct PokemonLandApp: App {
    var body: some Scene {
        WindowGroup {
            TabBar()
        }
    }
}

struct TabBar: View {
    var body: some View {
        TabView {
            NavigationView {
                ListView(viewModel: ListViewModel())
            }
            .configureNavigationForDevices()
            .tabItem {
                Label("Pokemons", systemImage: "smallcircle.circle.fill")
            }

            NavigationView {
                FavoritesListView(viewModel: FavoritesListViewModel())
            }
            .tabItem {
                Label("Favorites", systemImage: "star.fill")
            }
        }
    }
}
