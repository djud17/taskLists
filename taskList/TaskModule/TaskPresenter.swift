//
//  TaskPresenter.swift
//  taskList
//
//  Created by Давид Тоноян  on 11.12.2022.
//

import Foundation

protocol TaskPresenterProtocol: AnyObject {
    var delegate: TaskViewDelegate? { get set }
    
    func getPageTitle() -> String
    func getNumberOfItems() -> Int
    func getDataModel() -> [ItemProtocol]
    
    func addButtonTapped()
    func deleteButtonTapped(withItem item: ItemProtocol)
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
        router.openCreateTaskAlert { [weak self] itemName in
            let newItem = TaskItem(itemName: itemName)
            let isBadItem = self?.interactor.checkData(item: newItem) ?? true
            if isBadItem {
                throw DataError.noData
            } else {
                let index = self?.interactor.appendData(item: newItem) ?? 0
                self?.delegate?.insertData(forIndex: index)
            }
        }
    }
    
    func getPageTitle() -> String {
        return interactor.listEntity.entityName
    }
    
    func getNumberOfItems() -> Int {
        return interactor.listEntity.entityItems.count
    }
    
    func getDataModel() -> [ItemProtocol] {
        return interactor.listEntity.entityItems
    }
    
    func deleteButtonTapped(withItem item: ItemProtocol) {
        interactor.deleteData(item: item)
    }
    
    func cellTapped(forIndex index: Int) {
        interactor.changeItemStatus(forIndex: index)
    }
}
