//
//  GridViewPresenter.swift
//  TODO
//
//  Created by Artem Vavilov on 02.03.2023.
//

import Foundation
import RealmSwift

//MARK: - Protocols
protocol GridViewPresenterProtocol: AnyObject {
    func viewDidLoad()
    func addNewTask(index: Int)
    func didTaskEdit(taskModelDTO: TaskModelDTO, index: Int)
    func didTaskDelete(taskModelDTO: TaskModelDTO, index: Int)
    func closeTask(taskModelDTO: TaskModelDTO, index: Int)
    func closeTaskList(_ close: Bool)
}

final class GridViewPresenter {
    
    //MARK: - Public properties
    weak var controller: GridViewControllerProtocol?
    
    //MARK: - Private properties
    private var router: GridViewRouterProtocol?
    private let database: DatabaseProtocol
    private let notificationCenter: NotificationServiceProtocol?
    private let taskListDelegateService: TaskListDelegateService
    
    //MARK: - Init
    init(controller: GridViewControllerProtocol, router: GridViewRouterProtocol, taskListDelegateService: TaskListDelegateService) {
        self.controller = controller
        self.router = router
        self.database = DatabaseService()
        self.notificationCenter = NotificationService()
        self.taskListDelegateService = taskListDelegateService
    }
    
    //MARK: - Public func
    private func showDetails(item: TaskModelDTO, index: Int) {
        let cellService = TaskDelegateService(taskModelDTO: item) { [weak self] taskModelDTO in
            self?.updateData(with: taskModelDTO, on: index)
        }
        router?.showDetails(cellService: cellService)
    }
    
    private func updateData(with taskModelDTO: TaskModelDTO, on index: Int) {
        let taskModel = TaskModel(taskModelDTO)
        if let taskListModel = database.getObject(with: TaskListModel.self, by: taskListDelegateService.taskListModelDTO.id) {
           try? database.addTaskModelToList(taskModel, to: taskListModel)
        }
        controller?.updateData(with: taskModelDTO, on: index)
        
        //        NFServise
        if taskModelDTO.alarmOn {
            notificationCenter?.deleteNotifications(with: [taskModelDTO.id.uuidString])
            notificationCenter?.createNotification(taskName: taskModelDTO.taskDescription, date: taskModelDTO.date, id: taskModelDTO.id.uuidString)
        } else {
            notificationCenter?.deleteNotifications(with: [taskModelDTO.id.uuidString])
        }
    }
}

//MARK: - Protocol
extension GridViewPresenter: GridViewPresenterProtocol {
    func viewDidLoad() {
        var array = [TaskModelDTO]()
        
        if let taskList = database.getObject(with: TaskListModel.self, by: taskListDelegateService.taskListModelDTO.id) {
            taskList.items.forEach({ array.append(TaskModelDTO($0)) })
        }
        
        controller?.loadData(items: array)
    }
    
    func addNewTask(index: Int) {
        let taskModelDTO = TaskModelDTO(taskDescription: "", alarmOn: false, date: Date.now, condition: .new)
        showDetails(item: taskModelDTO, index: index)
    }
    
    func didTaskEdit(taskModelDTO: TaskModelDTO, index: Int) {
        showDetails(item: taskModelDTO, index: index)
    }
    
    func didTaskDelete(taskModelDTO: TaskModelDTO, index: Int) {
        if let taskModel = database.getObject(with: TaskModel.self, by: taskModelDTO.id) {
            try? database.delete(taskModel)
            
            //        NFServise
            notificationCenter?.deleteNotifications(with: [taskModelDTO.id.uuidString])
        }
        controller?.deleteData(on: index)
    }
    
    func closeTask(taskModelDTO: TaskModelDTO, index: Int) {
        let newTaskModelDTO = TaskModelDTO(
            taskModelDTO,
            taskDescription: taskModelDTO.taskDescription,
            alarmOn: false,
            date: taskModelDTO.date,
            condition: .closed
            )
        updateData(with: newTaskModelDTO, on: index)
    }
    
    func closeTaskList(_ close: Bool) {
        guard let taskListModel = database.getObject(with: TaskListModel.self, by: taskListDelegateService.taskListModelDTO.id) else { return }
        try? database.setCondition(taskListModel, condition: close ? .closed : .new)
        taskListDelegateService.closure(taskListDelegateService.taskListModelDTO.id)
    }
}
