//
//  ListInteractor.swift
//  taskList
//
//  Created by Давид Тоноян  on 08.12.2022.
//

import Foundation

protocol ListInteractorProtocol: AnyObject {
    var itemsArray: [EntityProtocol] { get }
    
    func loadDataFromPersistance()
    func checkData(entity: EntityProtocol) -> Bool
    func updateData(entity: EntityProtocol) -> Int
    func saveData(entity: EntityProtocol)
    func deleteData(entity: EntityProtocol)
}

final class ListInteractor: ListInteractorProtocol {
    private lazy var persistance: PersistanceProtocol = ServiceLocator.persistance
    private(set) var itemsArray: [EntityProtocol] = [ListEntity]()
    
    func loadDataFromPersistance() {
        itemsArray = persistance.readFromPersistance()
    }
    
    func checkData(entity: EntityProtocol) -> Bool {
        return entity.entityName.isEmpty
    }

    func saveData(entity: EntityProtocol) {
        persistance.writeToPersistance(entity: entity)
    }
    
    func deleteData(entity: EntityProtocol) {
        persistance.deleteFromPersistance(entity: entity)
        let index = itemsArray.firstIndex { $0.entityName == entity.entityName } ?? 0
        itemsArray.remove(at: index)
    }
    
    func updateData(entity: EntityProtocol) -> Int {
        itemsArray.append(entity)
        itemsArray.sort { $0.entityName < $1.entityName }
        let index = itemsArray.firstIndex { $0 === entity } ?? 0
        itemsArray = updateIdItems()
        return index
    }
    
    private func updateIdItems() -> [EntityProtocol] {
        var itemsWithId = [EntityProtocol]()
        
        for (index, item) in itemsArray.enumerated() {
            let newItem = item
            newItem.entityId = index
            itemsWithId.append(newItem)
            persistance.deleteFromPersistance(entity: item)
            persistance.writeToPersistance(entity: newItem)
        }
        return itemsWithId
    }
}
