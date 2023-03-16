//
//  ListViewController.swift
//  TODO
//
//  Created by Artem Vavilov on 09.03.2023.
//

import UIKit
import TinyConstraints

//MARK: - Protocols
protocol ListViewControllerProtocol: AnyObject {
    func loadData(items: [TaskListModelDTO])
    func updateData(item: TaskListModelDTO)
    func loadProfile(profileModel: ProfileModel)
}

final class ListViewController: UIViewController {
    
    //MARK: - Public properties
    var presenter: ListViewPresenterProtocol?
    
    //MARK: - Private properties
    private let backView = UIView()
    private let taskListHeaderView = TaskListHeaderView()
    private let tableView = UITableView()
    
    private var dataSource: [TaskListModelDTO] = [
    ] {
        didSet {
            sections = TypeSection.group(taskLists: dataSource)
            sections.sort { $0.type.rawValue < $1.type.rawValue }
            tableView.reloadData()
        }
    }
    
    private var sections: [TypeSection] = []
    
    //MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    //MARK: - Private func
    private func setup() {
        addSubviews()
        setupConstraints()
        setupView()
        setupTableView()
    }
    
    private func addSubviews() {
        view.addSubview(backView)
        backView.addSubview(taskListHeaderView)
        backView.addSubview(tableView)
    }
    
    private func setupConstraints() {
        backView.edgesToSuperview(usingSafeArea: true)
        
        taskListHeaderView.edgesToSuperview(excluding: .bottom, insets: .top(3))
        taskListHeaderView.bottomToTop(of: tableView, offset: -3)
        taskListHeaderView.heightToSuperview(multiplier: 0.07)
        tableView.edgesToSuperview(excluding: .top)
    }
    
    private func setupView() {
        title = "Task lists"
        view.backgroundColor = ColorsInter.background
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", image: nil, target: self, action: #selector(createTask))
        
        backView.backgroundColor = .clear
        taskListHeaderView.buttonAction = {
            self.presenter?.didHeaderTapped()
        }
    }
    
    private func setupTableView() {
        tableView.register(TaskListCellView.self, forCellReuseIdentifier: Constants.idetifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func configureContextMenu(index: Int) -> UIContextMenuConfiguration {
        let context = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (action) -> UIMenu? in
            let edit = UIAction(title: "Edit", image: UIImage(systemName: "square.and.pencil")) { (_)  in
                let item = self.dataSource[index]
                self.editTask(taskListModelDTO: item)
            }
            
            let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), identifier: nil, discoverabilityTitle: nil,attributes: .destructive, state: .off) { (_) in
                let taskListModelDTO = self.dataSource[index]
                self.presenter?.didTaskDelete(taskListModelDTO: taskListModelDTO)
                self.dataSource.remove(at: index)
            }
            
            return UIMenu(title: "Options", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [edit,delete])
        }
        
        return context
    }
    
    private func editTask(taskListModelDTO: TaskListModelDTO) {
        let alertController = UIAlertController(title: "Edit task:", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.text = taskListModelDTO.name
        }
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            let textField = alertController.textFields![0] as UITextField
            if let text = textField.text {
                self.presenter?.didTaskEdit(taskListModelDTO: taskListModelDTO, properties: ["name": text])
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - @objc
    @objc
    private func createTask() {
        let alertController = UIAlertController(title: "New task:", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter task name"
        }
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            let textField = alertController.textFields![0] as UITextField
            if let text = textField.text {
                self.presenter?.addNewTask(name: text)
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

//MARK: - Datasource\Delegate
extension ListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let type = sections[section].type
        switch type {
        case .new:
            return "New tasks"
        case .closed:
            return "Closed tasks"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].taskLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.idetifier, for: indexPath) as! TaskListCellView
        let section = sections[indexPath.section]
        let item = section.taskLists[indexPath.row]
        cell.configure(with: item)
        return cell
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        let item = section.taskLists[indexPath.row]
        presenter?.showDetails(taskListModelDTO: item)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let section = sections[indexPath.section]
        let item = section.taskLists[indexPath.row]
        if let index = dataSource.firstIndex(of: item) {
            return configureContextMenu(index: index)
        }
        return nil
    }
}

//MARK: - Protocol
extension ListViewController: ListViewControllerProtocol {
    func updateData(item: TaskListModelDTO) {
        if let index = dataSource.firstIndex(where: { $0.id == item.id }) {
            dataSource[index] = item
            tableView.reloadData()
        }
    }
    
    func loadData(items: [TaskListModelDTO]) {
        dataSource.append(contentsOf: items)
    }
    
    func loadProfile(profileModel: ProfileModel) {
        taskListHeaderView.configure(with: profileModel)
    }
}

//MARK: - Ext
extension ListViewController {
    enum Constants {
        static let idetifier = "taskListCellView"
    }
    
    struct TypeSection {
        var type: TaskCondition
        var taskLists: [TaskListModelDTO]
        
        static func group(taskLists : [TaskListModelDTO]) -> [TypeSection] {
            let groups = Dictionary(grouping: taskLists) { taskList in
                taskList.condition
            }
            return groups.map(TypeSection.init(type:taskLists:))
        }
    }
}
