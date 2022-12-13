//
//  ListModuleTests.swift
//  taskListTests
//
//  Created by Давид Тоноян  on 13.12.2022.
//

import XCTest
@testable import taskList
import CoreData
import Foundation

final class ListInteractorTests: XCTestCase {
    private let persistance = PersistanceMock.init()
    
    func testLoadDataFromPersistance() {
        let taskInteractor = ListInteractor(persistance: persistance)
        let itemsFromPersistance = persistance.entityMocks
        taskInteractor.loadDataFromPersistance()
        
        XCTAssertEqual(itemsFromPersistance.count, taskInteractor.entityArray.count)
        
        let index = Int.random(in: 0..<itemsFromPersistance.count)
        XCTAssertEqual(itemsFromPersistance[index].entityName, taskInteractor.entityArray[index].entityName)
        XCTAssertEqual(itemsFromPersistance[index].entityItems.count, taskInteractor.entityArray[index].entityItems.count)
        XCTAssertEqual(itemsFromPersistance[index].entityId, taskInteractor.entityArray[index].entityId)
    }
    
    func testCheckData() {
        let taskInteractor =  ListInteractor(persistance: persistance)
        let newEntity = ListEntityMock(entityId: 0, entityName: "list", entityItems: [])
        XCTAssertFalse(taskInteractor.checkData(entity: newEntity))
        newEntity.entityName = ""
        XCTAssertTrue(taskInteractor.checkData(entity: newEntity))
    }
    
    func testSaveData() {
        let taskInteractor =  ListInteractor(persistance: persistance)
        let newEntity = ListEntityMock(entityId: 0, entityName: "list", entityItems: [])
        let entityMockCount = persistance.entityMocks.count
        
        taskInteractor.saveData(entity: newEntity)
        
        let last = persistance.entityMocks.last
        XCTAssertEqual(persistance.entityMocks.count, entityMockCount + 1)
        XCTAssertEqual(last?.entityName, newEntity.entityName)
        XCTAssertEqual(last?.entityId, newEntity.entityId)
        XCTAssertEqual(last?.entityItems.count, newEntity.entityItems.count)
    }

    func testDeleteData() {
        let taskInteractor =  ListInteractor(persistance: persistance)
        taskInteractor.loadDataFromPersistance()
        let entityToDelete = ListEntityMock(entityId: 1, entityName: "test 2", entityItems: [])
        let entityArrayCount = taskInteractor.entityArray.count
        let persistanceArrayCount = persistance.entityMocks.count
        
        taskInteractor.deleteData(entity: entityToDelete)
        
        XCTAssertEqual(entityArrayCount - 1, taskInteractor.entityArray.count)
        XCTAssertEqual(persistanceArrayCount - 1, persistance.entityMocks.count)
        
        let index = Int.random(in: 0..<taskInteractor.entityArray.count)
        XCTAssertNotEqual(taskInteractor.entityArray[index].entityName, entityToDelete.entityName)
        XCTAssertNotEqual(taskInteractor.entityArray[index].entityId, entityToDelete.entityId)
        
        XCTAssertNotEqual(persistance.entityMocks[index].entityName, entityToDelete.entityName)
        XCTAssertNotEqual(persistance.entityMocks[index].entityId, entityToDelete.entityId)
    }
    
    func testUpdateData() {
        let taskInteractor =  ListInteractor(persistance: persistance)
        taskInteractor.loadDataFromPersistance()
        let newEntity = ListEntityMock(entityId: 0, entityName: "test 4", entityItems: [])
        let entityArrayCount = taskInteractor.entityArray.count
        
        let testIndex = taskInteractor.updateData(entity: newEntity)
        let sortedArray = taskInteractor.entityArray.sorted { $0.entityName < $1.entityName }
        
        // append test
        XCTAssertEqual(entityArrayCount + 1, taskInteractor.entityArray.count)
        
        // sort test
        XCTAssertTrue(sortedArray[0].entityName == taskInteractor.entityArray[0].entityName)
        XCTAssertTrue(sortedArray[1].entityName == taskInteractor.entityArray[1].entityName)
        XCTAssertTrue(sortedArray[2].entityName == taskInteractor.entityArray[2].entityName)
        XCTAssertTrue(sortedArray[3].entityName == taskInteractor.entityArray[3].entityName)
        
        XCTAssertTrue(sortedArray[0].entityId == taskInteractor.entityArray[0].entityId)
        XCTAssertTrue(sortedArray[1].entityId == taskInteractor.entityArray[1].entityId)
        XCTAssertTrue(sortedArray[2].entityId == taskInteractor.entityArray[2].entityId)
        XCTAssertTrue(sortedArray[3].entityId == taskInteractor.entityArray[3].entityId)
        
        // id test
        XCTAssertTrue(sortedArray[0].entityId == 0)
        XCTAssertTrue(sortedArray[1].entityId == 1)
        XCTAssertTrue(sortedArray[2].entityId == 2)
        XCTAssertTrue(sortedArray[3].entityId == 3)
        
        // index check
        XCTAssertEqual(testIndex, 3)
    }
}

private final class PersistanceMock: PersistanceProtocol {
    var converter: taskList.ConverterProtocol = ConverterMock.init()
    var entityMocks = [
        ListEntityMock(entityId: 0, entityName: "test 1", entityItems: []),
        ListEntityMock(entityId: 1, entityName: "test 2", entityItems: []),
        ListEntityMock(entityId: 2, entityName: "test 3", entityItems: [])
    ]
    
    func writeToPersistance(entity: taskList.EntityProtocol) {
        guard let entity = entity as? ListEntityMock else { return }
        
        entityMocks.append(entity)
    }
    
    func readFromPersistance() -> [taskList.EntityProtocol] { entityMocks }
    
    func deleteFromPersistance(entity: taskList.EntityProtocol) {
        let index = entityMocks.firstIndex { $0.entityId == entity.entityId } ?? 0
        entityMocks.remove(at: index)
    }
    
    func insertItemToList(forList listEntityId: Int, toIndex index: Int, item: taskList.ItemProtocol) { }
    func removeItemFromList(fromList listEntityId: Int, atIndex index: Int) { }
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
