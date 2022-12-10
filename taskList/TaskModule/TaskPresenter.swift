//
//  TaskPresenter.swift
//  taskList
//
//  Created by Давид Тоноян  on 11.12.2022.
//

import Foundation

protocol TaskPresenterProtocol {
    
}

final class TaskPresenter: TaskPresenterProtocol {
    private var interactor: TaskInteractorProtocol
    private var router: TaskRouterProtocol
    //weak var delegate: ListViewDelegate?
    
    init(interactor: TaskInteractorProtocol, router: TaskRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}
