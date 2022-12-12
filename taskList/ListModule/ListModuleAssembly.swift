//
//  ModuleAssembly.swift
//  taskList
//
//  Created by Давид Тоноян  on 08.12.2022.
//

import UIKit

protocol ListAssemblyProtocol {
    func asemblyListModule(navigationController: UINavigationController) -> ListViewProtocol
}

final class ListModuleAssembly: ListAssemblyProtocol {
    func asemblyListModule(navigationController: UINavigationController) -> ListViewProtocol {
        let interactor: ListInteractorProtocol = ListInteractor()
        let router: ListRouterProtocol = ListRouter(navigationController: navigationController)
        let presenter: ListPresenterProtocol = ListPresenter(interactor: interactor, router: router)
        let viewController = ListViewController(presenter: presenter)
        
        return viewController
    }
}
