//
//  ListEntity.swift
//  taskList
//
//  Created by Давид Тоноян  on 08.12.2022.
//

import Foundation

struct TaskList: EntityProtocol {
    var listName: String
    var listItems: [Task]
}
