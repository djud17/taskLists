//
//  TaskInteractor.swift
//  taskList
//
//  Created by Давид Тоноян  on 11.12.2022.
//

import Foundation

protocol TaskInteractorProtocol {
    var persistance: PersistanceProtocol { get set }
    
//    func getData() -> [any EntityProtocol]
//    func checkData(entityName: String) -> Bool
//    func saveData(entityName: String)
//    func deleteData(entity: any EntityProtocol)
}

final class TaskInteractor: TaskInteractorProtocol {
    var persistance: PersistanceProtocol
    
    init(persistance: PersistanceProtocol) {
        self.persistance = persistance
    }
}
