//
//  AddButton.swift
//  taskList
//
//  Created by Давид Тоноян  on 11.12.2022.
//

import UIKit

final class AddButton: UIButton {
    init() {
        super.init(frame: .zero)
        layer.cornerRadius = Constants.Size.cornerRadius
        backgroundColor = Constants.Color.white
        setTitleColor(Constants.Color.blue, for: .normal)
        setTitleColor(Constants.Color.lightBlue, for: .highlighted)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
