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
    
    func loadData()
    func addButtonTapped()
}

final class ListPresenter: PresenterProtocol {
    var interactor: InteractorProtocol
    var router: RouterProtocol
    
    weak var delegate: ViewDelegate?
    
    init(interactor: InteractorProtocol, router: RouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func loadData() {
        let dataArray = interactor.getData()
        delegate?.showData(dataArray: dataArray)
    }
    
    func addButtonTapped() {
        router.openCreateTaskView()
    }
}
