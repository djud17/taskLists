//
//  ModuleAssembly.swift
//  taskList
//
//  Created by Давид Тоноян  on 08.12.2022.
//

import UIKit

final class TaskListModuleAssembly: AssemblyProtocol {
    func asemblyModule() -> any ViewProtocol {
        let interactor: ListInteractorProtocol = ListInteractor()
        var router: ListRouterProtocol = ListRouter(navigationControler: .init())
        let presenter: any ListPresenterProtocol = ListPresenter(interactor: interactor, router: router)
        let viewController = ListViewController(presenter: presenter)
        router.navigationControler = UINavigationController(rootViewController: viewController)
        return viewController
    }
}
