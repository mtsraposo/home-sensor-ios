import Foundation
import UIKit

class SceneDelegate: UIResponder, UISceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let viewController = MainViewController()
        
        window.rootViewController = viewController
        self.window = window
        
        window.makeKeyAndVisible()
    }
}
