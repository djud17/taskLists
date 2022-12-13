//
//  SceneDelegate.swift
//  taskList
//
//  Created by Давид Тоноян  on 08.12.2022.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let navigationController = ServiceLocator.navigationController
        let listAssembly: ListModuleAssembly = ListModuleAssembly()
        let viewModule = listAssembly.asemblyListModule(navigationController: navigationController)
        
        navigationController.setViewControllers([viewModule], animated: false)
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
