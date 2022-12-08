//
//  ListInteractor.swift
//  taskList
//
//  Created by Давид Тоноян  on 08.12.2022.
//

import Foundation

protocol ListInteractorProtocol: InteractorProtocol {
    func getData() -> [any EntityProtocol]
}

final class ListInteractor: ListInteractorProtocol {
    var persistance: PersistanceProtocol?
    
    func getData() -> [any EntityProtocol] {
        var data: [any EntityProtocol] = []
        data.append(TaskList(listName: "Test1", listItems: []))
        data.append(TaskList(listName: "Test2", listItems: []))
        data.append(TaskList(listName: "Test3", listItems: []))
        return data
    }
}
