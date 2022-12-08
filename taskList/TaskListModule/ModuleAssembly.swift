//
//  ModuleAssembly.swift
//  taskList
//
//  Created by Давид Тоноян  on 08.12.2022.
//

import UIKit

protocol Assembly {
    func asemblyModule(viewController: UIViewController)
}

final class TaskListAssembly: Assembly {
    func asemblyModule(viewController: UIViewController) {
        //let interactor = ProfileInteractor()
        //let router = ProfileRouter()
        //let presenter = ProfilePresenter(interactor: interactor, router: router)
        let vc = ProfileViewController(profilePresenter: presenter)
    }
}
