//
//  TaskEntity.swift
//  taskList
//
//  Created by Давид Тоноян  on 11.12.2022.
//

import Foundation

protocol ItemProtocol {
    var itemName: String { get set }
}

struct Task: ItemProtocol {
    var itemName: String
}
