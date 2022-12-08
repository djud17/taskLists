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
        return []
    }
}

/*
final class ProfileInteractor {
    private var profileService: ProfileServiceProtocol = ProfileService()

    func name() -> String {
        profileService.profile.name
    }
}
*/
