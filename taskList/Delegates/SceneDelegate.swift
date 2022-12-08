//
//  SceneDelegate.swift
//  taskList
//
//  Created by Давид Тоноян  on 08.12.2022.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let taskListAssembly = TaskListAssembly()
//        let (router, controller) = assembly.assemble()
//        let nc = UINavigationController(rootViewController: controller)
//        window.rootViewController = nc
//        router.navigationController = nc
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
