//
//  Presenter.swift
//  taskList
//
//  Created by Давид Тоноян  on 08.12.2022.
//

import Foundation

protocol PresenterProtocol {
    var interactor: InteractorProtocol { get set }
    var router: RouterProtocol { get set }
    var delegate: ViewDelegate? { get set }
    
    func getDataFromPersistance()
}

final class ListPresenter: PresenterProtocol {
    var interactor: InteractorProtocol
    var router: RouterProtocol
    
    weak var delegate: ViewDelegate?
    
    init(interactor: InteractorProtocol, router: RouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func getDataFromPersistance() {
        let dataArray = interactor.getData()
        delegate?.showData(dataArray: dataArray)
    }
}

/*
class ProfilePresenter {

    let interactor: ProfileInteractor
    let router: ProfileRouter

    weak var delegate: ProfileDelegate?

    init(interactor: ProfileInteractor, router: ProfileRouter) {
        self.interactor = interactor
        self.router = router
    }

    func viewDidLoad() {
        let name = interactor.name()
        delegate?.update(entity: ProfileEntity(name: name))
    }

    func buttonTapped() {
        router.openSettings()
    }
}
*/
