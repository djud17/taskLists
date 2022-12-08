//
//  AddEntityViewController.swift
//  taskList
//
//  Created by Давид Тоноян  on 08.12.2022.
//

import UIKit
import SnapKit

final class AddEntityViewController: UIViewController, ViewProtocol {
    var presenter: any AddEntityPresenterProtocol
    
    private lazy var saveEntityButton: UIButton = {
        let button = UIButton()
        button.setTitle("Сохранить", for: .normal)
        button.addTarget(self, action: #selector(saveEntityButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = Constants.Sizes.cornerRadius
        button.backgroundColor = Constants.Colors.white
        button.setTitleColor(Constants.Colors.blue, for: .normal)
        button.setTitleColor(Constants.Colors.blue.withAlphaComponent(0.5), for: .highlighted)
        return button
    }()
    
    init(presenter: any AddEntityPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Constants.Colors.blue
        navigationController?.navigationBar.tintColor = UIColor.white
        
        view.addSubview(saveEntityButton)
        
        saveEntityButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
        }
    }
    
    @objc private func saveEntityButtonTapped() {
        print("ttt")
    }
}
