import SwiftUI

@main
struct PokemonLandApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ListView(viewModel: ListViewModel())
            }
            .configureNavigationForDevices()
        }
    }
}
