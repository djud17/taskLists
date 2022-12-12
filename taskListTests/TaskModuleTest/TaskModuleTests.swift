//
//  TaskModuleTests.swift
//  taskListTests
//
//  Created by Давид Тоноян  on 12.12.2022.
//

import XCTest
@testable import taskList
import CoreData

final class TaskModuleTests: XCTestCase {
    let persistance = PersistanceMock.init()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        persistance.entityMocks = [ListEntityMock.init()]
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        persistance.entityMocks.removeAll()
    }
    
    func testInteractorEntity() throws {
        let entity = ListEntityMock.init()
        let taskInteractor = TaskInteractor(persistance: persistance, listEntity: entity)
        XCTAssertEqual(entity.entityName, taskInteractor.listEntity.entityName)
        XCTAssertTrue(entity === taskInteractor.listEntity)
        XCTAssertEqual(entity.entityItems.count, taskInteractor.listEntity.entityItems.count)
    }
    
    func testInteractorLoadData() throws {
        let listInteractor = ListInteractor()
        listInteractor.loadDataFromPersistance()
        XCTAssertTrue(listInteractor.itemsArray.count == persistance.readFromPersistance().count)
    }
}

class PersistanceMock: PersistanceProtocol {
    var converter: taskList.ConverterProtocol = ConverterMock.init()
    
    var entityMocks = [ListEntityMock.init()]
    
    func writeToPersistance(entity: taskList.EntityProtocol) {
        
    }
    
    func readFromPersistance() -> [taskList.EntityProtocol] {
        entityMocks
    }
    
    func deleteFromPersistance(entity: taskList.EntityProtocol) {
        
    }
}

class ConverterMock: ConverterProtocol {
    func convertToPersistance(data: taskList.EntityProtocol) -> NSManagedObject? {
        nil
    }
    
    func convertFromPersistance(dataArray: [NSManagedObject]) -> [taskList.EntityProtocol] {
        []
    }
}

class ListEntityMock: EntityProtocol {
    var entityName: String = "Complete"
    var entityItems: [taskList.ItemProtocol] = []
}
