//
//  TaskModuleAssembly.swift
//  taskList
//
//  Created by Давид Тоноян  on 11.12.2022.
//

import UIKit

protocol TaskModuleAssemblyProtocol {
    func asemblyTaskModule(forListEntity listEntity: EntityProtocol) -> TaskViewProtocol
}

final class TaskModuleAssembly: TaskModuleAssemblyProtocol {
    private let persistance: PersistanceProtocol = ServiceLocator.persistance
    private let navigationController: UINavigationController = ServiceLocator.navigationController
    
    func asemblyTaskModule(forListEntity listEntity: EntityProtocol) -> TaskViewProtocol {
        let interactor: TaskInteractorProtocol = TaskInteractor(persistance: persistance,
                                                                listEntity: listEntity)
        let router: TaskRouterProtocol = TaskRouter(navigationController: navigationController)
        let presenter: TaskPresenterProtocol = TaskPresenter(interactor: interactor, router: router)
        let viewController = TaskViewController(presenter: presenter)
        
        return viewController
    }
}
