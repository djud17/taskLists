//
//  ViewController.swift
//  taskList
//
//  Created by Давид Тоноян  on 08.12.2022.
//

import UIKit
import SnapKit

protocol ViewDelegate: AnyObject {
    func showData(dataArray: [any DataProtocol])
}

final class ListViewController: UIViewController {
    var presenter: PresenterProtocol
    private var itemsArray: [any DataProtocol] = [TaskList]()
    
    private lazy var addListButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить список", for: .normal)
        button.addTarget(self, action: #selector(addListButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = Constants.Sizes.cornerRadius
        button.backgroundColor = Constants.Colors.blue
        button.setTitleColor(Constants.Colors.white, for: .normal)
        return button
    }()
    
    private lazy var listTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    init(presenter: PresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        listTableView.dataSource = self
        listTableView.allowsSelection = false
        listTableView.register(nibModels: [ListTableViewCellModel.self])
        
        view.addSubview(addListButton)
        view.addSubview(listTableView)
        
        addListButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
        }
        
        listTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(addListButton.snp.top).inset(20)
        }
        
        presenter.getDataFromPersistance()
    }
    
    @objc private func addListButtonTapped() {
        
    }
}

extension ListViewController: ViewDelegate {
    func showData(dataArray: [any DataProtocol]) {
        itemsArray = dataArray
        listTableView.reloadData()
    }
}

extension ListViewController: UITableViewDataSource {
    
    // MARK: - Configure TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let listName = itemsArray[indexPath.row].listName
        let model: CellViewAnyModel = ListTableViewCellModel(listName: listName)
        return tableView.dequeueReusableCell(withModel: model, for: indexPath)
    }
}
