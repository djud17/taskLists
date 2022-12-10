//
//  TaskModuleAssembly.swift
//  taskList
//
//  Created by Давид Тоноян  on 11.12.2022.
//

import UIKit

protocol TaskModuleAssemblyProtocol {
    func asemblyTaskModule(forListEntity listEntity: any EntityProtocol) -> TaskViewProtocol
}

final class TaskModuleAssembly: TaskModuleAssemblyProtocol {
    var persistance: PersistanceProtocol
    var converter: ConverterProtocol
    var navigationController: UINavigationController
    
    init(persistance: PersistanceProtocol, converter: ConverterProtocol, navigationController: UINavigationController?) {
        self.persistance = persistance
        self.converter = converter
        self.navigationController = navigationController ?? UINavigationController()
    }
    
    func asemblyTaskModule(forListEntity listEntity: any EntityProtocol) -> TaskViewProtocol {
        let interactor: TaskInteractorProtocol = TaskInteractor(persistance: persistance,
                                                                converter: converter)
        let router: TaskRouterProtocol = TaskRouter(navigationController: navigationController)
        let presenter: TaskPresenterProtocol = TaskPresenter(interactor: interactor, router: router)
        let viewController = TaskViewController(presenter: presenter, taskList: listEntity)
        
        return viewController
    }
}
