//
//  TaskViewController.swift
//  taskList
//
//  Created by Давид Тоноян  on 11.12.2022.
//

import UIKit

protocol TaskViewProtocol where Self: UIViewController {
    var presenter: TaskPresenterProtocol { get set }
}

final class TaskViewController: UIViewController, TaskViewProtocol {
    var presenter: TaskPresenterProtocol
    var taskList: any EntityProtocol
    
    private lazy var addTaskButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить задачу", for: .normal)
        button.addTarget(self, action: #selector(addTaskButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = Constants.Sizes.cornerRadius
        button.backgroundColor = Constants.Colors.white
        button.setTitleColor(Constants.Colors.blue, for: .normal)
        button.setTitleColor(Constants.Colors.lightBlue, for: .highlighted)
        return button
    }()
    
    private lazy var taskTableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = Constants.Sizes.cornerRadius
        tableView.separatorColor = Constants.Colors.blue
        tableView.separatorInset = .zero
        return tableView
    }()
    
    init(presenter: TaskPresenterProtocol, taskList: any EntityProtocol) {
        self.presenter = presenter
        self.taskList = taskList
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = Constants.Colors.blue
        
        navigationItem.title = taskList.listName
        
        view.addSubview(addTaskButton)
        view.addSubview(taskTableView)
        
        let mediumOffset = Constants.Sizes.mediumOffset
        addTaskButton.snp.makeConstraints { make in
            make.height.equalTo(Constants.Sizes.fieldHeight)
            make.leading.equalToSuperview().offset(mediumOffset)
            make.trailing.equalToSuperview().inset(mediumOffset)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(mediumOffset)
        }
        
        taskTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(mediumOffset)
            make.leading.equalToSuperview().offset(mediumOffset)
            make.trailing.equalToSuperview().inset(mediumOffset)
            make.bottom.equalTo(addTaskButton.snp.top).offset(-mediumOffset)
        }
    }
    
    @objc private func addTaskButtonTapped() {
        print("add task")
    }
}
