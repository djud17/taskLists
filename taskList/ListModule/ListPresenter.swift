//
//  Presenter.swift
//  taskList
//
//  Created by Давид Тоноян  on 08.12.2022.
//

import UIKit

protocol ListPresenterProtocol {
    var delegate: ListViewDelegate? { get set }
    
    func loadData()
    func addButtonTapped()
    func deleteButtonTapped(withEntity entity: any EntityProtocol)
    func getStartScreen() -> UIViewController?
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
    
    func loadData() {
        let dataArray = interactor.getData()
        delegate?.showData(dataArray: dataArray)
    }
    
    func addButtonTapped() {
        router.openCreateTaskAlert { [weak self] entityName in
            let entityIsEmpty = self?.interactor.checkData(entityName: entityName) ?? true
            if entityIsEmpty {
                throw DataError.noData
            } else {
                self?.interactor.saveData(entityName: entityName)
                let newEntity = ListEntity(listName: entityName, listItems: [])
                self?.delegate?.updateData(withEntity: newEntity)
            }
        }
    }
    
    func deleteButtonTapped(withEntity entity: any EntityProtocol) {
        interactor.deleteData(entity: entity)
    }
    
    func getStartScreen() -> UIViewController? {
        router.navigationController
    }
    
    func cellTapped(withEntity entity: any EntityProtocol) {
        let taskModuleAssembly = TaskModuleAssembly(persistance: interactor.persistance,
                                                    navigationController: router.navigationController)
        let viewModule = taskModuleAssembly.asemblyTaskModule(forListEntity: entity)
        router.openTaskModule(module: viewModule)
    }
}
