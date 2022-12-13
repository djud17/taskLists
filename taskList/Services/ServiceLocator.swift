//
//  ServiceLocator.swift
//  taskList
//
//  Created by Давид Тоноян  on 12.12.2022.
//

import UIKit

protocol ServiceLocatorProtocol {
    static var persistance: PersistanceProtocol { get }
    static var navigationController: UINavigationController { get }
}

final class ServiceLocator: ServiceLocatorProtocol {
    private(set) static var persistance: PersistanceProtocol = CoreDataPersistance()
    private(set) static var navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: Constants.Color.white
        ]
        navigationController.navigationBar.tintColor = Constants.Color.white
        
        return navigationController
    }()
}
