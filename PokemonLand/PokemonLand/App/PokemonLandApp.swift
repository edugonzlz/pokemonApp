import SwiftUI

@main
struct PokemonLandApp: App {

    @ObservedObject var viewModel = PokemonLandAppViewModel()

    var body: some Scene {
        WindowGroup {
            TabBar()
                .overlay(alignment: .bottom) {
                    if !viewModel.networkConnected {
                        ConnectionStatusView()
                            .offset(y: -49)
                    }
                }
        }
    }
}
