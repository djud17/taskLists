//
//  Constants.swift
//  taskList
//
//  Created by Давид Тоноян  on 08.12.2022.
//

import UIKit

enum Constants {
    enum Symbol {
        static let filledPoint = "\u{25C9}"
        static let emptyPoint = "\u{25CB}"
    }
    
    enum Color {
        static let blue = UIColor(red: 0, green: 0.46, blue: 0.9, alpha: 1)
        static let lightBlue = UIColor(red: 0, green: 0.46, blue: 0.9, alpha: 0.5)
        static let white: UIColor = .white
        static let red: UIColor = .red
    }
    
    enum Size {
        static let cornerRadius: CGFloat = 10
        static let borderWidth: CGFloat = 3
        
        static let fontSize: CGFloat = 17
        
        static let fieldHeight: CGFloat = 40
        static let alertFieldHeight: CGFloat = 150
        
        static let smallOffset: CGFloat = 20
        static let mediumOffset: CGFloat = 20
        static let largeOffset: CGFloat = 20
    }
    
    enum Text {
        static let mainPageTitle = "Списки задач"
        
        static let errorTitle = "Ошибка"
        static let errorData = "Введены некорректные данные"
        
        static let addListAlertTitle = "Новый список"
        static let addListButtonTitle = "Добавить список"
        
        static let addTaskAlertTitle = "Новая задача"
        static let addTaskButtonTitle = "Добавить задачу"
        
        static let textFieldPlaceholder = "Введите название"
        
        static let okButtonTitle = "OK"
    }
}
