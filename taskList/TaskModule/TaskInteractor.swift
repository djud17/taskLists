//
//  TaskInteractor.swift
//  taskList
//
//  Created by Давид Тоноян  on 11.12.2022.
//

import Foundation

protocol TaskInteractorProtocol {
    var persistance: PersistanceProtocol { get set }
    var itemTitle: String { get }
    var numberOfItems: Int { get }
    
    func getData() -> [any ItemProtocol]
    func checkData(item: any ItemProtocol) -> Bool
    func saveData()
    func appendData(item: any ItemProtocol) -> Int
    func deleteData(item: any ItemProtocol)
    func changeItemStatus(forIndex index: Int)
}

final class TaskInteractor: TaskInteractorProtocol {
    var persistance: PersistanceProtocol
    private var listEntity: EntityProtocol
    var numberOfItems: Int {
        listEntity.entityItems.count
    }
    var itemTitle: String {
        listEntity.entityName
    }
    
    init(persistance: PersistanceProtocol, listEntity: EntityProtocol) {
        self.persistance = persistance
        self.listEntity = listEntity
    }
    
    func checkData(item: any ItemProtocol) -> Bool {
        return item.itemName.isEmpty
    }
    
    func saveData() {
        persistance.deleteFromPersistance(entity: listEntity)
        persistance.writeToPersistance(entity: listEntity)
    }
    
    func getData() -> [any ItemProtocol] {
        return listEntity.entityItems
    }
    
    func appendData(item: any ItemProtocol) -> Int {
        listEntity.entityItems.append(item)
        listEntity.entityItems.sort { $0.itemName < $1.itemName }
        saveData()
        let index = listEntity.entityItems.firstIndex { $0.itemName == item.itemName } ?? 0
        return index
    }
    
    func deleteData(item: any ItemProtocol) {
        let index = listEntity.entityItems.firstIndex { $0.itemName == item.itemName } ?? 0
        listEntity.entityItems.remove(at: index)
        saveData()
    }
    
    func changeItemStatus(forIndex index: Int) {
        let item = listEntity.entityItems[index]
        let newStatus: ItemStatus = item.itemStatus == .planned ? .completed : .planned
        listEntity.entityItems[index].itemStatus = newStatus
        saveData()
    }
}
