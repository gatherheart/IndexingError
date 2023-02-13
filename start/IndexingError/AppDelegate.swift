import UIKit

/*
 If you check whether it is possible to import,
 the "No Such Module" error does not override compilation errors
 */

//#if canImport(AnimalFramework)
import AnimalFramework
//#endif

//#if canImport(StaticAnimals)
import StaticAnimals
//#endif

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Error().execute()
        return true
    }
}

