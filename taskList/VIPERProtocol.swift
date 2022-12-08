//
//  ViewProtocol.swift
//  taskList
//
//  Created by Давид Тоноян  on 08.12.2022.
//

import UIKit

protocol ViewProtocol where Self: UIViewController {
    var presenter: PresenterProtocol { get set }
}

protocol InteractorProtocol {
    var persistance: PersistanceProtocol? { get set }
}

protocol PresenterProtocol {
    var interactor: InteractorProtocol { get set }
    var router: RouterProtocol { get set }
    var delegate: ViewDelegate? { get set }
}

protocol EntityProtocol {
    associatedtype EntityItem
    var listName: String { get set }
    var listItems: [EntityItem] { get set }
}

protocol RouterProtocol {
    var navigationControler: UINavigationController? { get set }
}

protocol AssemblyProtocol {
    func asemblyModule() -> any ViewProtocol
}
