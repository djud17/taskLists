//
//  ListPresenterTests.swift
//  taskListTests
//
//  Created by Давид Тоноян  on 13.12.2022.
//

import XCTest
@testable import taskList
import CoreData
import Foundation

final class ListPresenterTests: XCTestCase {
    func testGetDataModel() {
        let interactor = ListInteractorMock()
        let router = ListRouterMock()
        let listPresenter = ListPresenter(interactor: interactor, router: router)
        
        let testArray = listPresenter.getDataModel()
        XCTAssertEqual(testArray.count, interactor.entityArray.count)
        
        let index = Int.random(in: 0..<interactor.entityArray.count)
        XCTAssertEqual(testArray[index].entityId, interactor.entityArray[index].entityId)
        XCTAssertEqual(testArray[index].entityName, interactor.entityArray[index].entityName)
        XCTAssertEqual(testArray[index].entityItems.count, interactor.entityArray[index].entityItems.count)
    }
    
    func testGetNumberOfItems() {
        let interactor = ListInteractorMock()
        let router = ListRouterMock()
        let listPresenter = ListPresenter(interactor: interactor, router: router)
        
        let testNumber = listPresenter.getNumberOfItems()
        XCTAssertEqual(testNumber, interactor.entityArray.count)
    }

    func testGetPageTitle() {
        let interactor = ListInteractorMock()
        let router = ListRouterMock()
        let listPresenter = ListPresenter(interactor: interactor, router: router)
        
        let testTitle = listPresenter.getPageTitle()
        
        XCTAssertEqual(testTitle, Constants.Text.mainPageTitle)
    }
}

private final class ListInteractorMock: ListInteractorProtocol {
    var entityArray: [taskList.EntityProtocol] = [
        ListEntityMock(entityId: 0, entityName: "list 1", entityItems: []),
        ListEntityMock(entityId: 0, entityName: "list 1", entityItems: []),
        ListEntityMock(entityId: 0, entityName: "list 1", entityItems: [])
    ]
    
    func loadDataFromPersistance() {
        
    }
    
    func checkData(entity: taskList.EntityProtocol) -> Bool {
        false
    }
    
    func updateData(entity: taskList.EntityProtocol) -> Int {
        1
    }
    
    func saveData(entity: taskList.EntityProtocol) {
        
    }
    
    func deleteData(entity: taskList.EntityProtocol) {
        
    }
    
    
}

private final class ListRouterMock: ListRouterProtocol {
    func openCreateListAlert(completion: @escaping (String) throws -> Void) {
        
    }
    
    func openTaskModule(module: taskList.TaskViewProtocol) {
        
    }
}

private final class ListEntityMock: EntityProtocol {
    var entityId: Int
    var entityName: String
    var entityItems: [taskList.ItemProtocol] = []
    
    init(entityId: Int, entityName: String, entityItems: [taskList.ItemProtocol]) {
        self.entityId = entityId
        self.entityName = entityName
        self.entityItems = entityItems
    }
}
