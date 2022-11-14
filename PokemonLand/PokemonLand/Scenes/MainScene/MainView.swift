import SwiftUI

struct MainView<M: MainViewModelProtocol>: View {

    @StateObject var viewModel: M

    var body: some View {
        TabView {
            NavigationStack {
                ListView(viewModel: ListViewModel())
            }
            .configureNavigationForDevices()
            .tabItem {
                Label("Pokemons", systemImage: "smallcircle.circle.fill")
            }

            NavigationStack {
                FavoritesListView(viewModel: FavoritesListViewModel())
            }
            .configureNavigationForDevices()
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
