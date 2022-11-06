# Pokemon App

## This app present some concepts about iOS app architecture and modularization.

- App.xcworkspace contains two different projects and have some services modularized. The concept is about handle some different apps thats make use of same services or UI components.
- Both use pokeapi.co API to present info about Pokemons
- App is modularized with SPM. Uses two local packages, for retrieve info about pokemons and user. Both these dependes on CommonCore package, with Api connection features (with Result, Combine and Async/Await public methods) and more
- PokemonLand
    - App developed with SwiftUI and MVVM architecture.
    - Uses Combine library to make app reactive, like favorites behavior
    - Present a paginated list of pokemons
    - Allows to add element to favorite
    - Elements are cached in memory
    - Favorites are saved in database (UserDefaults in this case)
    - Allows to search elements (Search is local because API don’t have a search endpoint)
    - Present view with connection info when device is not connected to some network 
- PokemonWorld
    - App developed with UIKit and VIPER architecture
    - Uses Combine 
    - Present a paginated list of pokemons
    - Elements are cached in memory


## How to install

- Download code
- Open App.xcworkspace with XCode 14
- Wait for download dependencies. Project use SPM and this make it automatically.
- Select scheme
- Run