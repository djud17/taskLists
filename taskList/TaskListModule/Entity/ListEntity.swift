//
//  ListEntity.swift
//  taskList
//
//  Created by Давид Тоноян  on 08.12.2022.
//

import Foundation

protocol DataProtocol {
    associatedtype DataTask
    var listName: String { get set }
    var listItems: [DataTask] { get set }
}

struct TaskList: DataProtocol {
    var listName: String
    var listItems: [Task]
}
