//
//  TaskRouter.swift
//  taskList
//
//  Created by Давид Тоноян  on 11.12.2022.
//

import UIKit

protocol TaskRouterProtocol {
    func openCreateTaskAlert(completion: @escaping (String) throws -> Void)
}

final class TaskRouter: TaskRouterProtocol {
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func openCreateTaskAlert(completion: @escaping (String) throws -> Void) {
        let alertController = UIAlertController(title: "Create task", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Введите название"
        }
        let addButton = UIAlertAction(title: "Добавить задачу", style: .default) { [weak self] _ in
            if let entityName = alertController.textFields?.first?.text {
                do {
                    try completion(entityName)
                } catch {
                    self?.showErrorMessage()
                }
            }
        }
        alertController.addAction(addButton)
        navigationController?.present(alertController, animated: true)
    }
    
    private func showErrorMessage() {
        let alertController = UIAlertController(title: "Error", message: "Введены некорректные данные", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(okButton)
        navigationController?.present(alertController, animated: true)
    }
}
