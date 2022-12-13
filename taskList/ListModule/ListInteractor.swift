//
//  ListInteractor.swift
//  taskList
//
//  Created by Давид Тоноян  on 08.12.2022.
//

import Foundation

protocol ListInteractorProtocol: AnyObject {
    var entityArray: [EntityProtocol] { get }
    
    func loadDataFromPersistance()
    func checkData(entity: EntityProtocol) -> Bool
    func updateData(entity: EntityProtocol) -> Int
    func saveData(entity: EntityProtocol)
    func deleteData(entity: EntityProtocol)
}

final class ListInteractor: ListInteractorProtocol {
    private let persistance: PersistanceProtocol
    private(set) var entityArray: [EntityProtocol] = [ListEntity]()
    
    init(persistance: PersistanceProtocol) {
        self.persistance = persistance
    }
    
    func loadDataFromPersistance() {
        entityArray = persistance.readFromPersistance()
    }
    
    func checkData(entity: EntityProtocol) -> Bool {
        return entity.entityName.isEmpty
    }

    func saveData(entity: EntityProtocol) {
        persistance.writeToPersistance(entity: entity)
    }
    
    func deleteData(entity: EntityProtocol) {
        persistance.deleteFromPersistance(entity: entity)
        let index = entityArray.firstIndex { $0.entityName == entity.entityName } ?? 0
        entityArray.remove(at: index)
    }
    
    func updateData(entity: EntityProtocol) -> Int {
        entityArray.append(entity)
        entityArray.sort { $0.entityName < $1.entityName }
        let index = entityArray.firstIndex { $0 === entity } ?? 0
        entityArray = createArrayWithId()
        return index
    }
    
    private func createArrayWithId() -> [EntityProtocol] {
        var entityArrayWithId = [EntityProtocol]()
        
        for (index, entity) in entityArray.enumerated() {
            let newEntity = entity
            newEntity.entityId = index
            entityArrayWithId.append(newEntity)
            persistance.deleteFromPersistance(entity: entity)
            persistance.writeToPersistance(entity: newEntity)
        }
        return entityArrayWithId
    }
}
