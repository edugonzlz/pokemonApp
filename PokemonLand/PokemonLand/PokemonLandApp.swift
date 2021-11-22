import SwiftUI

@main
struct PokemonLandApp: App {
    var body: some Scene {
        WindowGroup {
            ListView(viewModel: ListViewModel())
        }
    }
}
