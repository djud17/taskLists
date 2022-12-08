//
//  AddEntityInteractor.swift
//  taskList
//
//  Created by Давид Тоноян  on 08.12.2022.
//

import UIKit

protocol AddEntityInteractorProtocol: InteractorProtocol {
    func saveData()
}

final class AddEntityInteractor: AddEntityInteractorProtocol {
    var persistance: PersistanceProtocol?

    func saveData() {
        
    }
}
