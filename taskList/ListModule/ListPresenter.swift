//
//  Presenter.swift
//  taskList
//
//  Created by Давид Тоноян  on 08.12.2022.
//

import UIKit

protocol ListPresenterProtocol {
    var delegate: ListViewDelegate? { get set }
    
    func getStartScreen() -> UIViewController?
    func getPageTitle() -> String
    
    func loadInitialData()
    func getNumberOfItems() -> Int
    func getDataModel() -> [any EntityProtocol]
    
    func addButtonTapped()
    func deleteButtonTapped(withEntity entity: any EntityProtocol)
    func cellTapped(withEntity entity: any EntityProtocol)
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
    
    func getDataModel() -> [any EntityProtocol] {
        return interactor.getData()
    }
    
    func getNumberOfItems() -> Int {
        return interactor.numberOfItems
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
    
    func deleteButtonTapped(withEntity entity: any EntityProtocol) {
        interactor.deleteData(entity: entity)
    }
    
    func getStartScreen() -> UIViewController? {
        return router.navigationController
    }
    
    func cellTapped(withEntity entity: any EntityProtocol) {
        let taskModuleAssembly = TaskModuleAssembly(persistance: interactor.persistance,
                                                    navigationController: router.navigationController)
        let viewModule = taskModuleAssembly.asemblyTaskModule(forListEntity: entity)
        router.openTaskModule(module: viewModule)
    }
}
