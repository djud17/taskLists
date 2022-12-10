//
//  ListRouter.swift
//  taskList
//
//  Created by Давид Тоноян  on 08.12.2022.
//

import UIKit

protocol ListRouterProtocol {
    var navigationControler: UINavigationController? { get set }
    
    func openCreateTaskAlert(completion: @escaping (String) throws -> Void)
}

final class ListRouter: ListRouterProtocol {
    weak var navigationControler: UINavigationController?
    
    init(navigationControler: UINavigationController) {
        self.navigationControler = navigationControler
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
        navigationControler?.present(alertController, animated: true)
    }
    
    private func showErrorMessage() {
        let alertController = UIAlertController(title: "Error", message: "Введены некорректные данные", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(okButton)
        navigationControler?.present(alertController, animated: true)
    }
}
