//
//  TaskViewController.swift
//  taskList
//
//  Created by Давид Тоноян  on 11.12.2022.
//

import UIKit

protocol TaskViewDelegate: AnyObject {
    func showData()
    func insertData(forIndex index: Int)
}

protocol TaskViewProtocol where Self: UIViewController {
    
}

final class TaskViewController: UIViewController, TaskViewProtocol {
    private let presenter: TaskPresenterProtocol
    
    private lazy var addTaskButton: AddButton = {
        let button = AddButton()
        button.setTitle(Constants.Text.addTaskButtonTitle, for: .normal)
        button.addTarget(self, action: #selector(addTaskButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var taskTableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = Constants.Size.cornerRadius
        tableView.separatorColor = Constants.Color.blue
        tableView.separatorInset = .zero
        return tableView
    }()
    
    init(presenter: TaskPresenterProtocol) {
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
    }
    
    private func setupView() {
        view.backgroundColor = Constants.Color.blue
        
        navigationItem.title = presenter.getPageTitle()
        
        configurateTableView()
        setupButtonConstraints()
        setupTableViewConstraints()
    }
    
    @objc private func addTaskButtonTapped() {
        presenter.addButtonTapped()
    }
    
    private func configurateTableView() {
        taskTableView.dataSource = self
        taskTableView.delegate = self
        taskTableView.register(nibModels: [TaskTableViewCellModel.self])
    }
    
    private func setupButtonConstraints() {
        let mediumOffset = Constants.Size.mediumOffset
        
        view.addSubview(addTaskButton)
        
        addTaskButton.snp.makeConstraints { make in
            make.height.equalTo(Constants.Size.fieldHeight)
            make.leading.equalToSuperview().offset(mediumOffset)
            make.trailing.equalToSuperview().inset(mediumOffset)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(mediumOffset)
        }
    }
    
    private func setupTableViewConstraints() {
        let mediumOffset = Constants.Size.mediumOffset
        
        view.addSubview(taskTableView)
        
        taskTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(mediumOffset)
            make.leading.equalToSuperview().offset(mediumOffset)
            make.trailing.equalToSuperview().inset(mediumOffset)
            make.bottom.equalTo(addTaskButton.snp.top).offset(-mediumOffset)
        }
    }
}

extension TaskViewController: TaskViewDelegate {
    func showData() {
        taskTableView.reloadData()
    }
    
    func insertData(forIndex index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        taskTableView.insertRows(at: [indexPath], with: .fade)
    }
}

extension TaskViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getNumberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let items = presenter.getDataModel()
        let taskName = items[indexPath.row].itemName
        let taskStatus = items[indexPath.row].itemStatus
        let model: CellViewAnyModel = TaskTableViewCellModel(taskStatus: taskStatus, taskName: taskName)
        
        return tableView.dequeueReusableCell(withModel: model, for: indexPath)
    }
}

extension TaskViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let items = presenter.getDataModel()
            let entity = items[indexPath.row]
            presenter.deleteButtonTapped(withItem: entity)
            taskTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.cellTapped(forIndex: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
}
