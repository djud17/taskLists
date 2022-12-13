//
//  ListRouter.swift
//  taskList
//
//  Created by Давид Тоноян  on 08.12.2022.
//

import UIKit

protocol ListRouterProtocol {
    func openCreateListAlert(completion: @escaping (String) throws -> Void)
    func openTaskModule(module: TaskViewProtocol)
}

final class ListRouter: ListRouterProtocol {
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func openCreateListAlert(completion: @escaping (String) throws -> Void) {
        let alertController = UIAlertController(title: Constants.Text.addListAlertTitle,
                                                message: nil,
                                                preferredStyle: .alert)
        let alertTextField: UITextField = {
            let textField = UITextField()
            textField.placeholder = Constants.Text.textFieldPlaceholder
            textField.borderStyle = .roundedRect
            
            return textField
        }()
        
        alertController.view.addSubview(alertTextField)
        
        alertController.view.snp.makeConstraints { make in
            make.height.equalTo(Constants.Size.alertFieldHeight)
        }
        
        setupAlertTextFieldConstraints(alertTextField: alertTextField)
        
        let addButton = UIAlertAction(title: Constants.Text.addListButtonTitle, style: .default) { [weak self] _ in
            if let entityName = alertTextField.text {
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
    
    private func setupAlertTextFieldConstraints(alertTextField: UITextField) {
        guard let superView = alertTextField.superview else { return }
        
        alertTextField.snp.makeConstraints { make in
            make.height.equalTo(Constants.Size.fieldHeight)
            make.center.equalTo(superView.snp.center)
            make.leading.equalToSuperview().offset(Constants.Size.smallOffset)
            make.trailing.equalToSuperview().inset(Constants.Size.smallOffset)
        }
    }
    
    private func showErrorMessage() {
        let alertController = UIAlertController(title: Constants.Text.errorTitle,
                                                message: Constants.Text.errorData,
                                                preferredStyle: .alert)
        let okButton = UIAlertAction(title: Constants.Text.okButtonTitle, style: .default)
        alertController.addAction(okButton)
        navigationController?.present(alertController, animated: true)
    }
    
    func openTaskModule(module: TaskViewProtocol) {
        navigationController?.pushViewController(module, animated: true)
    }
}
