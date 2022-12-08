//
//  ListRouter.swift
//  taskList
//
//  Created by Давид Тоноян  on 08.12.2022.
//

import UIKit

protocol ListRouterProtocol: RouterProtocol {
    func openCreateTaskView()
}

final class ListRouter: ListRouterProtocol {
    weak var navigationControler: UINavigationController?
    
    init(navigationControler: UINavigationController) {
        self.navigationControler = navigationControler
    }
    
    func openCreateTaskView() {
        let addEntityAssembly: AssemblyProtocol = AddEntityModuleAssembly()
        let viewModule = addEntityAssembly.asemblyModule()
        navigationControler?.pushViewController(viewModule, animated: true)
    }
}
