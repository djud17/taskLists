//
//  ModuleAssembly.swift
//  taskList
//
//  Created by Давид Тоноян  on 08.12.2022.
//

import UIKit

protocol AssemblyProtocol {
    func asemblyModule() -> ViewProtocol
}

final class TaskListModuleAssembly: AssemblyProtocol {
    func asemblyModule() -> ViewProtocol {
        let interactor: InteractorProtocol = ListInteractor()
        var router: RouterProtocol = ListRouter(navigationControler: .init())
        let presenter: PresenterProtocol = ListPresenter(interactor: interactor, router: router)
        let viewController = ListViewController(presenter: presenter)
        router.navigationControler = UINavigationController(rootViewController: viewController)
        return viewController
    }
}
