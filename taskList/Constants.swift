//
//  Constants.swift
//  taskList
//
//  Created by Давид Тоноян  on 08.12.2022.
//

import UIKit

enum Constants {
    enum Symbols {
        static let filledPoint = "\u{25C9}"
        static let emptyPoint = "\u{25CB}"
    }
    
    enum Colors {
        static let blue = UIColor(red: 0, green: 0.46, blue: 0.9, alpha: 1)
        static let lightBlue = UIColor(red: 0, green: 0.46, blue: 0.9, alpha: 0.5)
        static let white: UIColor = .white
        static let red: UIColor = .red
    }
    
    enum Sizes {
        static let cornerRadius: CGFloat = 10
        static let borderWidth: CGFloat = 3
        
        static let fontSize: CGFloat = 17
        
        static let fieldHeight: CGFloat = 40
        
        static let smallOffset: CGFloat = 20
        static let mediumOffset: CGFloat = 20
        static let largeOffset: CGFloat = 20
    }
}
