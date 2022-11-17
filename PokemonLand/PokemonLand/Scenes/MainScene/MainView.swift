import SwiftUI

struct MainView<M: MainViewModelProtocol>: View {

    @StateObject var viewModel: M

    var body: some View {
        TabView {
            ForEach(viewModel.tabItems) { item in
                viewModel.getView(for: item)
                    .tabItem {
                        Label(item.kind.name, systemImage: item.kind.image)
                    }
                    .configureNavigationForDevices()
            }
        }
        .accentColor(.cyan)
        .onAppear {
            viewModel.setup()
            configureTabBar()
        }
        .overlay(alignment: .bottom) {
            if !viewModel.networkConnected {
                ConnectionStatusView()
                    .offset(y: -49)
            }
        }
    }
}

// MARK: - Private
private extension MainView {
    func configureTabBar() {
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().backgroundColor = .white
    }
}
