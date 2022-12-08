//
//  Persistance.swift
//  taskList
//
//  Created by Давид Тоноян  on 08.12.2022.
//

import Foundation

protocol ItemProtocol {
    var itemName: String { get set }
}
        
struct Task: ItemProtocol {
    var itemName: String
}




/*
protocol ProfileServiceProtocol {
    var profile: Profile { get }
}

final class ProfileService: ProfileServiceProtocol {
    lazy var profile: Profile = .init(name: "David")
}

struct Profile {
    let name: String
}
*/
