//
//  TaskModuleTests.swift
//  taskListTests
//
//  Created by Давид Тоноян  on 12.12.2022.
//

import XCTest
@testable import taskList
import CoreData

final class TaskInteractorTests: XCTestCase {
    private let persistance = PersistanceMock.init()
    private let entity = ListEntityMock(entityId: 1, entityName: "test 2", entityItems: [])
    
    func testInteractorEntity() {
        let taskInteractor = TaskInteractor(persistance: persistance, listEntity: entity)
        XCTAssertEqual(entity.entityName, taskInteractor.listEntity.entityName)
        XCTAssertEqual(entity.entityId, taskInteractor.listEntity.entityId)
        XCTAssertEqual(entity.entityItems.count, taskInteractor.listEntity.entityItems.count)
        XCTAssertTrue(entity === taskInteractor.listEntity)
    }
    
    func testInteractorCheckData() {
        let taskInteractor = TaskInteractor(persistance: persistance, listEntity: entity)
        let newItem = TaskEntityMock(itemName: "testItem", itemStatus: .planned, itemId: 0)
        XCTAssertFalse(taskInteractor.checkData(item: newItem))
        newItem.itemName = ""
        XCTAssertTrue(taskInteractor.checkData(item: newItem))
    }
    
    func testInteractorAppendData() {
        entity.entityItems = [
            TaskEntityMock(itemName: "testItem 3", itemStatus: .planned, itemId: 0),
            TaskEntityMock(itemName: "testItem 2", itemStatus: .planned, itemId: 0),
            TaskEntityMock(itemName: "testItem 1", itemStatus: .planned, itemId: 0)
        ]
        let taskInteractor = TaskInteractor(persistance: persistance, listEntity: entity)
        let newItem = TaskEntityMock(itemName: "testItem 4", itemStatus: .planned, itemId: 0)
        let arrayCount = taskInteractor.listEntity.entityItems.count
        
        let newItemIndex = taskInteractor.appendData(item: newItem)
        let sortedArray = entity.entityItems.sorted { $0.itemName < $1.itemName }
        
        // append item test
        XCTAssertEqual(arrayCount + 1, taskInteractor.listEntity.entityItems.count)
        
        // sort test
        XCTAssertTrue(sortedArray[0].itemName == taskInteractor.listEntity.entityItems[0].itemName)
        XCTAssertTrue(sortedArray[1].itemName == taskInteractor.listEntity.entityItems[1].itemName)
        XCTAssertTrue(sortedArray[2].itemName == taskInteractor.listEntity.entityItems[2].itemName)
        XCTAssertTrue(sortedArray[3].itemName == taskInteractor.listEntity.entityItems[3].itemName)
        
        XCTAssertTrue(sortedArray[0].itemId == taskInteractor.listEntity.entityItems[0].itemId)
        XCTAssertTrue(sortedArray[1].itemId == taskInteractor.listEntity.entityItems[1].itemId)
        XCTAssertTrue(sortedArray[2].itemId == taskInteractor.listEntity.entityItems[2].itemId)
        XCTAssertTrue(sortedArray[3].itemId == taskInteractor.listEntity.entityItems[3].itemId)
        
        // update id test
        XCTAssertTrue(sortedArray[0].itemId == 0)
        XCTAssertTrue(sortedArray[1].itemId == 1)
        XCTAssertTrue(sortedArray[2].itemId == 2)
        XCTAssertTrue(sortedArray[3].itemId == 3)
        
        XCTAssertTrue(newItemIndex == 3)
    }
    
    func testInteractorDeleteData() {
        entity.entityItems = [
            TaskEntityMock(itemName: "testItem 1", itemStatus: .planned, itemId: 0),
            TaskEntityMock(itemName: "testItem 2", itemStatus: .planned, itemId: 1),
            TaskEntityMock(itemName: "testItem 2", itemStatus: .planned, itemId: 2),
            TaskEntityMock(itemName: "testItem 3", itemStatus: .planned, itemId: 3)
        ]
        persistance.entityMocks = [
            ListEntityMock(entityId: 0, entityName: "test 1", entityItems: []),
            ListEntityMock(entityId: 1, entityName: "test 2", entityItems: [
                TaskEntityMock(itemName: "testItem 1", itemStatus: .planned, itemId: 0),
                TaskEntityMock(itemName: "testItem 2", itemStatus: .planned, itemId: 1),
                TaskEntityMock(itemName: "testItem 2", itemStatus: .planned, itemId: 2),
                TaskEntityMock(itemName: "testItem 3", itemStatus: .planned, itemId: 3)
            ]),
            ListEntityMock(entityId: 2, entityName: "test 3", entityItems: [])
        ]
        
        let taskInteractor = TaskInteractor(persistance: persistance, listEntity: entity)
        let arrayCount = entity.entityItems.count - 1
        let itemToDelete = TaskEntityMock(itemName: "testItem 2", itemStatus: .planned, itemId: 1)
        
        taskInteractor.deleteData(item: itemToDelete)
        XCTAssertEqual(entity.entityItems.count, arrayCount)
        
        XCTAssertFalse(entity.entityItems[0].itemId == itemToDelete.itemId)
        XCTAssertFalse(entity.entityItems[1].itemId == itemToDelete.itemId)
        XCTAssertFalse(entity.entityItems[2].itemId == itemToDelete.itemId)
        
        XCTAssertTrue(persistance.entityMocks[1].entityName == entity.entityName)
        
        XCTAssertFalse(persistance.entityMocks[1].entityItems[0].itemId == itemToDelete.itemId)
        XCTAssertFalse(persistance.entityMocks[1].entityItems[1].itemId == itemToDelete.itemId)
        XCTAssertFalse(persistance.entityMocks[1].entityItems[2].itemId == itemToDelete.itemId)
    }
    
    func testInteractorChangeItemStatus() {
        entity.entityItems = [
            TaskEntityMock(itemName: "testItem 1", itemStatus: .planned, itemId: 0),
            TaskEntityMock(itemName: "testItem 2", itemStatus: .planned, itemId: 1),
            TaskEntityMock(itemName: "testItem 2", itemStatus: .planned, itemId: 2),
            TaskEntityMock(itemName: "testItem 3", itemStatus: .planned, itemId: 3)
        ]
        persistance.entityMocks = [
            ListEntityMock(entityId: 0, entityName: "test 1", entityItems: []),
            ListEntityMock(entityId: 1, entityName: "test 2", entityItems: [
                TaskEntityMock(itemName: "testItem 1", itemStatus: .planned, itemId: 0),
                TaskEntityMock(itemName: "testItem 2", itemStatus: .planned, itemId: 1),
                TaskEntityMock(itemName: "testItem 2", itemStatus: .planned, itemId: 2),
                TaskEntityMock(itemName: "testItem 3", itemStatus: .planned, itemId: 3)
            ]),
            ListEntityMock(entityId: 2, entityName: "test 3", entityItems: [])
        ]
        
        let taskInteractor = TaskInteractor(persistance: persistance, listEntity: entity)
        let index = Int.random(in: 0..<4)
        taskInteractor.changeItemStatus(forIndex: index)
        
        XCTAssertTrue(entity.entityItems[index].itemStatus == .completed)
        
        XCTAssertFalse(persistance.entityMocks[1].entityItems[index].itemStatus == .planned)
        XCTAssertTrue(persistance.entityMocks[1].entityItems[index].itemStatus == .completed)
    }
}

private final class PersistanceMock: PersistanceProtocol {
    var converter: taskList.ConverterProtocol = ConverterMock.init()
    var entityMocks = [ListEntityMock]()
    
    func writeToPersistance(entity: taskList.EntityProtocol) { }
    func readFromPersistance() -> [taskList.EntityProtocol] { entityMocks }
    func deleteFromPersistance(entity: taskList.EntityProtocol) { }
    func insertItemToList(forList listEntityId: Int,
                          toIndex index: Int,
                          item: taskList.ItemProtocol) { entityMocks[listEntityId].entityItems.insert(item, at: index) }
    func removeItemFromList(fromList listEntityId: Int,
                            atIndex index: Int) { entityMocks[listEntityId].entityItems.remove(at: index) }
    func appendItemToList(forList listEntityId: Int, item: taskList.ItemProtocol) { }
    func removeItemFromList(fromList listEntityId: Int, item: taskList.ItemProtocol) { }
}

private final class ConverterMock: ConverterProtocol {
    func convertToPersistance(data: taskList.EntityProtocol) -> NSManagedObject? { nil }
    func convertFromPersistance(dataArray: [NSManagedObject]) -> [taskList.EntityProtocol] { [] }
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
