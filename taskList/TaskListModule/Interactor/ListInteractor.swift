//
//  ListInteractor.swift
//  taskList
//
//  Created by Давид Тоноян  on 08.12.2022.
//

import Foundation

protocol InteractorProtocol {
    func getData() -> [any DataProtocol]
}

final class ListInteractor: InteractorProtocol {
    func getData() -> [any DataProtocol] {
        var data: [any DataProtocol] = []
        data.append(TaskList(listName: "Test1", listItems: []))
        data.append(TaskList(listName: "Test2", listItems: []))
        data.append(TaskList(listName: "Test3", listItems: []))
        return data
    }
}
