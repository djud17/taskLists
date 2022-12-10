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
        let taskListAssembly: TaskListModuleAssembly = TaskListModuleAssembly()
        let viewModule = taskListAssembly.asemblyTaskListModule()
        let navigationController = viewModule.presenter.getStartScreen()
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
