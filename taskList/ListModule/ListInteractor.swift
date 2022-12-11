//
//  ListInteractor.swift
//  taskList
//
//  Created by Давид Тоноян  on 08.12.2022.
//

import Foundation

protocol ListInteractorProtocol {
    var persistance: PersistanceProtocol { get set }
    
    func getData() -> [any EntityProtocol]
    func checkData(entityName: String) -> Bool
    func saveData(entityName: String)
    func deleteData(entity: any EntityProtocol)
}

final class ListInteractor: ListInteractorProtocol {
    var persistance: PersistanceProtocol
    
    init(persistance: PersistanceProtocol) {
        self.persistance = persistance
    }
    
    func getData() -> [any EntityProtocol] {
        let data: [any EntityProtocol] = persistance.readFromPersistance()
        
        return data
    }
    
    func checkData(entityName: String) -> Bool {
        return entityName.isEmpty
    }

    func saveData(entityName: String) {
        persistance.writeToPersistance(entityName: entityName)
    }
    
    func deleteData(entity: any EntityProtocol) {
        persistance.deleteFromPersistance(entity: entity)
    }
}
