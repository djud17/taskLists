//
//  AddEntityModuleAssembly.swift
//  taskList
//
//  Created by Давид Тоноян  on 08.12.2022.
//

import UIKit

final class AddEntityModuleAssembly: AssemblyProtocol {
    func asemblyModule() -> any ViewProtocol {
        let interactor: AddEntityInteractorProtocol = AddEntityInteractor()
        var router: AddEntityRouterProtocol = AddEntityRouter()
        let presenter: any AddEntityPresenterProtocol = AddEntityPresenter(interactor: interactor,
                                                                       router: router)
        let viewController = AddEntityViewController(presenter: presenter)
        router.navigationControler = UINavigationController(rootViewController: viewController)
        return viewController
    }
}
