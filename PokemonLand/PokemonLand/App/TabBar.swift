import SwiftUI

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
        .accentColor(.purple)
        .onAppear {
            UITabBar.appearance().backgroundImage = UIImage()
            UITabBar.appearance().isTranslucent = true
            UITabBar.appearance().backgroundColor = .white
        }
    }
}
