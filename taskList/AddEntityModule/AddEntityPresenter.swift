//
//  AddEntityPresenter.swift
//  taskList
//
//  Created by Давид Тоноян  on 08.12.2022.
//

import Foundation

protocol AddEntityPresenterProtocol: PresenterProtocol {
    func saveButtonTapped()
}

final class AddEntityPresenter: AddEntityPresenterProtocol {
    var interactor: AddEntityInteractorProtocol
    var router: AddEntityRouterProtocol
    var delegate: ViewDelegate?
    
    init(interactor: AddEntityInteractorProtocol, router: AddEntityRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func saveButtonTapped() {
        
    }
}
