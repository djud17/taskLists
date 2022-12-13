//
//  TaskModulePresenterTests.swift
//  taskListTests
//
//  Created by Давид Тоноян  on 13.12.2022.
//

import XCTest
@testable import taskList
import CoreData

final class TaskPresenterTests: XCTestCase {
    private let entity = ListEntityMock(entityId: 1, entityName: "test 2", entityItems: [
        TaskEntityMock(itemName: "testItem 1", itemStatus: .planned, itemId: 0),
        TaskEntityMock(itemName: "testItem 2", itemStatus: .planned, itemId: 1),
        TaskEntityMock(itemName: "testItem 2", itemStatus: .planned, itemId: 2),
        TaskEntityMock(itemName: "testItem 3", itemStatus: .planned, itemId: 3)
    ])
    
    func testGetPageTitle() {
        let taskInteractor = TaskInteractorMock(listEntity: entity)
        let taskRouter = TaskRouterMock()
        let taskPresenter = TaskPresenter(interactor: taskInteractor, router: taskRouter)
        
        let testFuncTitle = taskPresenter.getPageTitle()
        let entityTitle = entity.entityName
        
        XCTAssertEqual(testFuncTitle, entityTitle)
    }
    
    func testGetNumberOfItems() {
        let taskInteractor = TaskInteractorMock(listEntity: entity)
        let taskRouter = TaskRouterMock()
        let taskPresenter = TaskPresenter(interactor: taskInteractor, router: taskRouter)
        
        let testFuncNumber = taskPresenter.getNumberOfItems()
        let entityNumber = entity.entityItems.count
        
        XCTAssertEqual(testFuncNumber, entityNumber)
    }
    
    func testGetDataModelFunc() {
        let taskInteractor = TaskInteractorMock(listEntity: entity)
        let taskRouter = TaskRouterMock()
        let taskPresenter = TaskPresenter(interactor: taskInteractor, router: taskRouter)
        
        let testFuncItems = taskPresenter.getDataModel()
        
        XCTAssertEqual(testFuncItems.count, entity.entityItems.count)
        
        let index = Int.random(in: 0..<4)
        XCTAssertEqual(testFuncItems[index].itemName, entity.entityItems[index].itemName)
        XCTAssertEqual(testFuncItems[index].itemStatus, entity.entityItems[index].itemStatus)
        XCTAssertEqual(testFuncItems[index].itemId, entity.entityItems[index].itemId)
        
    }
}

private final class TaskInteractorMock: TaskInteractorProtocol {
    var listEntity: taskList.EntityProtocol
    
    init(listEntity: EntityProtocol) {
        self.listEntity = listEntity
    }
    
    func checkData(item: taskList.ItemProtocol) -> Bool { item.itemName.isEmpty }
    func appendData(item: taskList.ItemProtocol) -> Int { 0 }
    func deleteData(item: taskList.ItemProtocol) { }
    func changeItemStatus(forIndex index: Int) { }
}

private final class TaskRouterMock: TaskRouterProtocol {
    func openCreateTaskAlert(completion: @escaping (String) throws -> Void) { }
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

private final class TaskEntityMock: ItemProtocol {
    var itemName: String
    var itemStatus: taskList.ItemStatus
    var itemId: Int
    
    init(itemName: String, itemStatus: ItemStatus, itemId: Int) {
        self.itemId = itemId
        self.itemStatus = itemStatus
        self.itemName = itemName
    }
}
