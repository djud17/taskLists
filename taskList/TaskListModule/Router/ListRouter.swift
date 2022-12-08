//
//  ListRouter.swift
//  taskList
//
//  Created by Давид Тоноян  on 08.12.2022.
//

import UIKit

protocol RouterProtocol {
    var navigationControler: UINavigationController? { get set }
    
    func openCreateTaskView()
}

final class ListRouter: RouterProtocol {
    weak var navigationControler: UINavigationController?
    
    init(navigationControler: UINavigationController) {
        self.navigationControler = navigationControler
    }
    
    func openCreateTaskView() {
        let addViewController = AddEntityViewController()
        navigationControler?.pushViewController(addViewController, animated: true)
    }
}
