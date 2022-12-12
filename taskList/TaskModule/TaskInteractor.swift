//
//  TaskInteractor.swift
//  taskList
//
//  Created by Давид Тоноян  on 11.12.2022.
//

import Foundation

protocol TaskInteractorProtocol {
    var listEntity: EntityProtocol { get }
    
    func checkData(item: ItemProtocol) -> Bool
    func appendData(item: ItemProtocol) -> Int
    func deleteData(item: ItemProtocol)
    func changeItemStatus(forIndex index: Int)
}

final class TaskInteractor: TaskInteractorProtocol {
    private var persistance: PersistanceProtocol
    private(set) var listEntity: EntityProtocol
    private lazy var listId = listEntity.entityId
    
    init(persistance: PersistanceProtocol, listEntity: EntityProtocol) {
        self.persistance = persistance
        self.listEntity = listEntity
    }
    
    func checkData(item: ItemProtocol) -> Bool {
        return item.itemName.isEmpty
    }
    
    func appendData(item: ItemProtocol) -> Int {
        listEntity.entityItems.append(item)
        listEntity.entityItems.sort { $0.itemName < $1.itemName }
        let index = listEntity.entityItems.firstIndex { $0 === item } ?? 0
        listEntity.entityItems = updateIdItems()
        return index
    }
    
    func deleteData(item: ItemProtocol) {
        let index = listEntity.entityItems.firstIndex { $0.itemId == item.itemId } ?? 0
        listEntity.entityItems.remove(at: index)
        persistance.removeItemFromList(fromList: listId, atIndex: index)
    }
    
    func changeItemStatus(forIndex index: Int) {
        let item = listEntity.entityItems[index]
        let newStatus: ItemStatus = item.itemStatus == .planned ? .completed : .planned
        listEntity.entityItems[index].itemStatus = newStatus
        persistance.removeItemFromList(fromList: listId, atIndex: index)
        persistance.insertItemToList(forList: listId, toIndex: index, item: listEntity.entityItems[index])
    }
    
    private func updateIdItems() -> [ItemProtocol] {
        var itemsWithId = [ItemProtocol]()
        
        for (index, item) in listEntity.entityItems.enumerated() {
            let newItem = item
            newItem.itemId = index
            itemsWithId.append(newItem)
            
            persistance.removeItemFromList(fromList: listId, item: item)
            persistance.appendItemToList(forList: listId, item: newItem)
        }
        return itemsWithId
    }
}
