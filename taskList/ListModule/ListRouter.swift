//
//  ListRouter.swift
//  taskList
//
//  Created by Давид Тоноян  on 08.12.2022.
//

import UIKit

protocol ListRouterProtocol {
    var navigationController: UINavigationController? { get set }
    
    func openCreateTaskAlert(completion: @escaping (String) throws -> Void)
    func openTaskModule(module: TaskViewProtocol)
}

final class ListRouter: ListRouterProtocol {
    weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func openCreateTaskAlert(completion: @escaping (String) throws -> Void) {
        let alertController = UIAlertController(title: "Create list", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Введите название"
        }
        let okButton = UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
            if let entityName = alertController.textFields?.first?.text {
                do {
                    try completion(entityName)
                } catch {
                    self?.showErrorMessage()
                }
            }
        }
        alertController.addAction(okButton)
        navigationController?.present(alertController, animated: true)
    }
    
    private func showErrorMessage() {
        let alertController = UIAlertController(title: "Error", message: "Введены некорректные данные", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(okButton)
        navigationController?.present(alertController, animated: true)
    }
    
    func openTaskModule(module: TaskViewProtocol) {
        navigationController?.pushViewController(module, animated: true)
    }
}
