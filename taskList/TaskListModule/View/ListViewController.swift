//
//  ViewController.swift
//  taskList
//
//  Created by Давид Тоноян  on 08.12.2022.
//

import UIKit
import SnapKit

protocol ViewProtocol where Self: UIViewController {
    var presenter: PresenterProtocol { get set }
}

protocol ViewDelegate: AnyObject {
    func showData(dataArray: [any DataProtocol])
}

final class ListViewController: UIViewController, ViewProtocol {
    var presenter: PresenterProtocol
    private var itemsArray: [any DataProtocol] = [TaskList]()
    
    private lazy var addListButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить список", for: .normal)
        button.addTarget(self, action: #selector(addListButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = Constants.Sizes.cornerRadius
        button.backgroundColor = Constants.Colors.blue
        button.setTitleColor(Constants.Colors.white, for: .normal)
        button.setTitleColor(Constants.Colors.white.withAlphaComponent(0.5), for: .highlighted)
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
        
        setupView()
        configureTableView()
        presenter.loadData()
    }
    
    @objc private func addListButtonTapped() {
        presenter.addButtonTapped()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(addListButton)
        view.addSubview(listTableView)
        
        addListButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
        }
        
        listTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(addListButton.snp.top).offset(-20)
        }
    }
    
    private func configureTableView() {
        listTableView.dataSource = self
        listTableView.allowsSelection = false
        listTableView.register(nibModels: [ListTableViewCellModel.self])
    }
}

extension ListViewController: ViewDelegate {
    func showData(dataArray: [any DataProtocol]) {
        itemsArray = dataArray
        listTableView.reloadData()
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let listName = itemsArray[indexPath.row].listName
        let model: CellViewAnyModel = ListTableViewCellModel(listName: listName)
        return tableView.dequeueReusableCell(withModel: model, for: indexPath)
    }
}
