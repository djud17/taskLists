//
//  ViewController.swift
//  taskList
//
//  Created by Давид Тоноян  on 08.12.2022.
//

import UIKit
import SnapKit

protocol ListViewDelegate: AnyObject {
    func showData(dataArray: [any EntityProtocol])
    func updateData(withEntity entity: any EntityProtocol)
}

protocol ListViewProtocol where Self: UIViewController {
    var presenter: ListPresenterProtocol { get set }
}

final class ListViewController: UIViewController, ListViewProtocol {
    var presenter: ListPresenterProtocol
    private var itemsArray: [any EntityProtocol] = [ListEntity]() {
        didSet {
            itemsArray.sort { $0.listName < $1.listName }
        }
    }
    
    private lazy var addListButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить список", for: .normal)
        button.addTarget(self, action: #selector(addListButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = Constants.Sizes.cornerRadius
        button.backgroundColor = Constants.Colors.white
        button.setTitleColor(Constants.Colors.blue, for: .normal)
        button.setTitleColor(Constants.Colors.lightBlue, for: .highlighted)
        return button
    }()
    
    private lazy var listTableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = Constants.Sizes.cornerRadius
        tableView.separatorColor = Constants.Colors.blue
        tableView.separatorInset = .zero
        return tableView
    }()
    
    init(presenter: ListPresenterProtocol) {
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.loadData()
    }
    
    @objc private func addListButtonTapped() {
        presenter.addButtonTapped()
    }
    
    private func setupView() {
        navigationItem.title = "Task lists"
        
        view.backgroundColor = Constants.Colors.blue
        
        view.addSubview(addListButton)
        view.addSubview(listTableView)
        
        let mediumOffset = Constants.Sizes.mediumOffset
        
        addListButton.snp.makeConstraints { make in
            make.height.equalTo(Constants.Sizes.fieldHeight)
            make.leading.equalToSuperview().offset(mediumOffset)
            make.trailing.equalToSuperview().inset(mediumOffset)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(mediumOffset)
        }
        
        listTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(mediumOffset)
            make.leading.equalToSuperview().offset(mediumOffset)
            make.trailing.equalToSuperview().inset(mediumOffset)
            make.bottom.equalTo(addListButton.snp.top).offset(-mediumOffset)
        }
    }
    
    private func configureTableView() {
        listTableView.dataSource = self
        listTableView.delegate = self
        listTableView.register(nibModels: [ListTableViewCellModel.self])
    }
}

extension ListViewController: ListViewDelegate {
    func showData(dataArray: [any EntityProtocol]) {
        itemsArray = dataArray
        listTableView.reloadData()
    }
    
    func updateData(withEntity entity: any EntityProtocol) {
        itemsArray.append(entity)
        let index = itemsArray.firstIndex { $0.listName == entity.listName } ?? 0
        let indexPath = IndexPath(row: index, section: 0)
        listTableView.insertRows(at: [indexPath], with: .fade)
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

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entity = itemsArray[indexPath.row]
            presenter.deleteButtonTapped(withEntity: entity)
            itemsArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEntity = itemsArray[indexPath.row]
        presenter.cellTapped(withEntity: selectedEntity)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
