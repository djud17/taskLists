//
//  ModuleAssembly.swift
//  taskList
//
//  Created by Давид Тоноян  on 08.12.2022.
//

import UIKit

protocol TaskListAssemblyProtocol {
    func asemblyTaskListModule() -> ListViewProtocol
}

final class TaskListModuleAssembly: TaskListAssemblyProtocol {
    func asemblyTaskListModule() -> ListViewProtocol {
        let persistance = CoreDataPersistance()
        let converter = CoreDataConverter()
        let interactor: ListInteractorProtocol = ListInteractor(persistance: persistance,
                                                                converter: converter)
        var router: ListRouterProtocol = ListRouter(navigationControler: .init())
        let presenter: ListPresenterProtocol = ListPresenter(interactor: interactor, router: router)
        let viewController = ListViewController(presenter: presenter)
        router.navigationControler = UINavigationController(rootViewController: viewController)
        
        return viewController
    }
}
