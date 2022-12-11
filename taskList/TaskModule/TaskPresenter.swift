//
//  TaskPresenter.swift
//  taskList
//
//  Created by Давид Тоноян  on 11.12.2022.
//

import Foundation

protocol TaskPresenterProtocol {
    var delegate: TaskViewDelegate? { get set }
    
    func addButtonTapped()
    func getPageTitle() -> String
    func getNumberOfItems() -> Int
    func getDataModel() -> [any ItemProtocol]
    func deleteButtonTapped(withItem item: any ItemProtocol)
    func cellTapped(forIndex index: Int)
}

final class TaskPresenter: TaskPresenterProtocol {
    private var interactor: TaskInteractorProtocol
    private var router: TaskRouterProtocol
    weak var delegate: TaskViewDelegate?
    
    init(interactor: TaskInteractorProtocol, router: TaskRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func addButtonTapped() {
        router.openCreateTaskAlert { [weak self] entityName in
            let newEntity = TaskItem(itemName: entityName)
            let isBadEntity = self?.interactor.checkData(item: newEntity) ?? true
            if isBadEntity {
                throw DataError.noData
            } else {
                let index = self?.interactor.appendData(item: newEntity) ?? 0
                self?.delegate?.insertData(forIndex: index)
            }
        }
    }
    
    func getPageTitle() -> String {
        return interactor.itemTitle
    }
    
    func getNumberOfItems() -> Int {
        return interactor.numberOfItems
    }
    
    func getDataModel() -> [any ItemProtocol] {
        return interactor.getData()
    }
    
    func deleteButtonTapped(withItem item: any ItemProtocol) {
        interactor.deleteData(item: item)
    }
    
    func cellTapped(forIndex index: Int) {
        interactor.changeItemStatus(forIndex: index)
    }
}
