//
//  Presenter.swift
//  taskList
//
//  Created by Давид Тоноян  on 08.12.2022.
//

import Foundation

protocol ListPresenterProtocol: PresenterProtocol {
    func loadData()
    func addButtonTapped()
}

final class ListPresenter: ListPresenterProtocol {
    var interactor: ListInteractorProtocol
    var router: ListRouterProtocol
    weak var delegate: ViewDelegate?
    
    init(interactor: ListInteractorProtocol, router: ListRouterProtocol) {
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
