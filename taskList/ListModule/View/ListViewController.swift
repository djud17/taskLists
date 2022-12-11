//
//  ViewController.swift
//  taskList
//
//  Created by Давид Тоноян  on 08.12.2022.
//

import UIKit
import SnapKit

protocol ListViewDelegate: AnyObject {
    func showData()
    func insertData(forIndex index: Int)
}

protocol ListViewProtocol where Self: UIViewController {
    var presenter: ListPresenterProtocol { get set }
}

final class ListViewController: UIViewController, ListViewProtocol {
    var presenter: ListPresenterProtocol

    private lazy var addListButton: AddButton = {
        let button = AddButton()
        button.setTitle("Добавить список", for: .normal)
        button.addTarget(self, action: #selector(addListButtonTapped), for: .touchUpInside)
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
        
        presenter.loadInitialData()
    }
    
    @objc private func addListButtonTapped() {
        presenter.addButtonTapped()
    }
    
    private func setupView() {
        navigationItem.title = presenter.getPageTitle()
        
        view.backgroundColor = Constants.Colors.blue
        
        setupButtonConstraints()
        setupTableConstraints()
    }
    
    private func configureTableView() {
        listTableView.dataSource = self
        listTableView.delegate = self
        listTableView.register(nibModels: [ListTableViewCellModel.self])
    }
    
    private func setupButtonConstraints() {
        let mediumOffset = Constants.Sizes.mediumOffset
        
        view.addSubview(addListButton)
        
        addListButton.snp.makeConstraints { make in
            make.height.equalTo(Constants.Sizes.fieldHeight)
            make.leading.equalToSuperview().offset(mediumOffset)
            make.trailing.equalToSuperview().inset(mediumOffset)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(mediumOffset)
        }
    }
    
    private func setupTableConstraints() {
        let mediumOffset = Constants.Sizes.mediumOffset
        
        view.addSubview(listTableView)
        
        listTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(mediumOffset)
            make.leading.equalToSuperview().offset(mediumOffset)
            make.trailing.equalToSuperview().inset(mediumOffset)
            make.bottom.equalTo(addListButton.snp.top).offset(-mediumOffset)
        }
        
    }
}

extension ListViewController: ListViewDelegate {
    func showData() {
        listTableView.reloadData()
    }
    
    func insertData(forIndex index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        listTableView.insertRows(at: [indexPath], with: .fade)
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getNumberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let items = presenter.getDataModel()
        let listName = items[indexPath.row].entityName
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
            let items = presenter.getDataModel()
            let entity = items[indexPath.row]
            presenter.deleteButtonTapped(withEntity: entity)
            listTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let items = presenter.getDataModel()
        let selectedEntity = items[indexPath.row]
        presenter.cellTapped(withEntity: selectedEntity)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
