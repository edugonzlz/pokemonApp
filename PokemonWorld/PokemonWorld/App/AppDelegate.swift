import UIKit
import PokemonServices
import Combine

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        let vc = ListWireframe().setup()
        let navVC = UINavigationController(rootViewController: vc)
        window?.rootViewController = navVC

        return true
    }
}
