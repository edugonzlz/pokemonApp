import SwiftUI

struct MainView<M: MainViewModelProtocol>: View {

    @StateObject var viewModel: M

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
        .accentColor(.cyan)
        .onAppear {
            UITabBar.appearance().backgroundImage = UIImage()
            UITabBar.appearance().isTranslucent = true
            UITabBar.appearance().backgroundColor = .white
        }
        .overlay(alignment: .bottom) {
            if !viewModel.networkConnected {
                ConnectionStatusView()
                    .offset(y: -49)
            }
        }
    }
}
