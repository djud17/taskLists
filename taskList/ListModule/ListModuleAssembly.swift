//
//  ModuleAssembly.swift
//  taskList
//
//  Created by Давид Тоноян  on 08.12.2022.
//

import UIKit

protocol ListAssemblyProtocol {
    func asemblyListModule() -> ListViewProtocol
}

final class ListModuleAssembly: ListAssemblyProtocol {
    func asemblyListModule() -> ListViewProtocol {
        let persistance: PersistanceProtocol = CoreDataPersistance()
        let interactor: ListInteractorProtocol = ListInteractor(persistance: persistance)
        var router: ListRouterProtocol = ListRouter(navigationController: .init())
        let presenter: ListPresenterProtocol = ListPresenter(interactor: interactor, router: router)
        let viewController = ListViewController(presenter: presenter)
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: Constants.Colors.white
        ]
        navigationController.navigationBar.tintColor = Constants.Colors.white
        
        router.navigationController = navigationController
        
        return viewController
    }
}
