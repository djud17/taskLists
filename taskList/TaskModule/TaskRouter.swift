//
//  TaskRouter.swift
//  taskList
//
//  Created by Давид Тоноян  on 11.12.2022.
//

import UIKit

protocol TaskRouterProtocol {
    var navigationController: UINavigationController? { get set }
}

final class TaskRouter: TaskRouterProtocol {
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}
