//
//  Presenter.swift
//  taskList
//
//  Created by Давид Тоноян  on 08.12.2022.
//

import UIKit

protocol ListPresenterProtocol: AnyObject {
    var delegate: ListViewDelegate? { get set }
    
    func getPageTitle() -> String
    
    func loadInitialData()
    func getNumberOfItems() -> Int
    func getDataModel() -> [EntityProtocol]
    
    func addButtonTapped()
    func deleteButtonTapped(withEntity entity: EntityProtocol)
    func cellTapped(withEntity entity: EntityProtocol)
}

enum DataError: Error {
    case noData
}

final class ListPresenter: ListPresenterProtocol {
    private var interactor: ListInteractorProtocol
    private var router: ListRouterProtocol
    weak var delegate: ListViewDelegate?
    
    init(interactor: ListInteractorProtocol, router: ListRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func loadInitialData() {
        interactor.loadDataFromPersistance()
        delegate?.showData()
    }
    
    func getDataModel() -> [EntityProtocol] {
        return interactor.itemsArray
    }
    
    func getNumberOfItems() -> Int {
        return interactor.itemsArray.count
    }
    
    func getPageTitle() -> String {
        return "Task Lists"
    }
    
    func addButtonTapped() {
        router.openCreateListAlert { [weak self] entityName in
            let newEntity = ListEntity(entityName: entityName, entityItems: [])
            let isBadEntity = self?.interactor.checkData(entity: newEntity) ?? true
            if isBadEntity {
                throw DataError.noData
            } else {
                let index = self?.interactor.updateData(entity: newEntity) ?? 0
                self?.delegate?.insertData(forIndex: index)
            }
        }
    }
    
    func deleteButtonTapped(withEntity entity: EntityProtocol) {
        interactor.deleteData(entity: entity)
    }
    
    func cellTapped(withEntity entity: EntityProtocol) {
        let taskModuleAssembly = TaskModuleAssembly()
        let viewModule = taskModuleAssembly.asemblyTaskModule(forListEntity: entity)
        router.openTaskModule(module: viewModule)
    }
}
