//
//  LiskViewPresenter.swift
//  TODO
//
//  Created by Artem Vavilov on 09.03.2023.
//

import Foundation

//MARK: - Protocol
protocol ListViewPresenterProtocol: AnyObject {
    func viewDidLoad()
    func addNewTask(name: String)
    func showDetails(taskListModelDTO: TaskListModelDTO)
    func didTaskDelete(taskListModelDTO: TaskListModelDTO)
    func didTaskEdit(taskListModelDTO: TaskListModelDTO, properties: [String: Any])
}

final class ListViewPresenter {
    
    //MARK: - Public properties
    weak var controller: ListViewControllerProtocol?
    
    //MARK: - Private properties
    private var router: ListViewRouterProtocol?
    private let database: DatabaseProtocol
    private let notificationCenter: NotificationServiceProtocol?
    
    //MARK: - Init
    init(controller: ListViewControllerProtocol, router: ListViewRouterProtocol) {
        self.controller = controller
        self.router = router
        self.database = DatabaseService()
        self.notificationCenter = NotificationService()
    }
}

//MARK: - Protocol
extension ListViewPresenter: ListViewPresenterProtocol {
    func viewDidLoad() {
        var array = [TaskListModelDTO]()
        if let data = database.getObjects(with: TaskListModel.self) {
            data.forEach({ array.append(TaskListModelDTO($0)) })
        }
        controller?.loadData(items: array)
    }
    
    func addNewTask(name: String) {
        let taskListModelDTO = TaskListModelDTO(name: name)
        try? database.saveObject(TaskListModel(taskListModelDTO))
        controller?.loadData(items: [taskListModelDTO])
    }
    
    func showDetails(taskListModelDTO: TaskListModelDTO) {
        let delegate = TaskListDelegateService(taskListModelDTO: taskListModelDTO) { [weak self] id in
            if let taskListModel = self?.database.getObject(with: TaskListModel.self, by: id) {
                let taskListModelDTO = TaskListModelDTO(taskListModel)
                self?.controller?.updateData(item: taskListModelDTO)
            }
        }
        router?.showDetails(taskListDelegateService: delegate)
    }
    
    func didTaskDelete(taskListModelDTO: TaskListModelDTO) {
        if let taskListModel = database.getObject(with: TaskListModel.self, by: taskListModelDTO.id) {
            let idArray = taskListModel.items.compactMap({ $0.id })
            
            //        NFServise + clear DB
            notificationCenter?.deleteNotifications(with: idArray.compactMap({$0.uuidString }))
            taskListModel.items.forEach {
                try? database.delete($0)
            }
            try? database.delete(taskListModel)
        }
    }
    
    func didTaskEdit(taskListModelDTO: TaskListModelDTO, properties: [String: Any]) {
        if let taskListModel = database.getObject(with: TaskListModel.self, by: taskListModelDTO.id) {
            properties.forEach {
                try? database.setValue(taskListModel, value: $1, forKey: $0)
            }
            DispatchQueue.main.async {
                self.controller?.updateData(item: TaskListModelDTO(taskListModel))
            }
        }
    }
}
