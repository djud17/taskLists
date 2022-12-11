//
//  ListInteractor.swift
//  taskList
//
//  Created by Давид Тоноян  on 08.12.2022.
//

import Foundation

protocol ListInteractorProtocol {
    var persistance: PersistanceProtocol { get set }
    var numberOfItems: Int { get }
    
    func loadDataFromPersistance() 
    func getData() -> [any EntityProtocol]
    func checkData(entity: any EntityProtocol) -> Bool
    func updateData(entity: any EntityProtocol) -> Int
    func saveData(entity: any EntityProtocol)
    func deleteData(entity: any EntityProtocol)
}

final class ListInteractor: ListInteractorProtocol {
    var persistance: PersistanceProtocol
    private var itemsArray: [any EntityProtocol] = [ListEntity]() {
        didSet {
            itemsArray.sort { $0.entityName < $1.entityName }
        }
    }
    var numberOfItems: Int {
        return itemsArray.count
    }
    
    init(persistance: PersistanceProtocol) {
        self.persistance = persistance
    }
    
    func loadDataFromPersistance() {
        itemsArray = persistance.readFromPersistance()
    }
    
    func getData() -> [any EntityProtocol] {
        return itemsArray
    }
    
    func checkData(entity: any EntityProtocol) -> Bool {
        return entity.entityName.isEmpty
    }

    func saveData(entity: any EntityProtocol) {
        persistance.writeToPersistance(entity: entity)
    }
    
    func deleteData(entity: any EntityProtocol) {
        persistance.deleteFromPersistance(entity: entity)
        let index = itemsArray.firstIndex { $0.entityName == entity.entityName } ?? 0
        itemsArray.remove(at: index)
    }
    
    func updateData(entity: any EntityProtocol) -> Int {
        saveData(entity: entity)
        itemsArray.append(entity)
        let index = itemsArray.firstIndex { $0.entityName == entity.entityName } ?? 0
        return index
    }
}
