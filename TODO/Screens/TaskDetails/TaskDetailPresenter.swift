//
//  TaskDetailPresenter.swift
//  TODO
//
//  Created by Artem Vavilov on 03.03.2023.
//

import Foundation

//MARK: - Protocols
protocol TaskDetailPresenterProtocol: AnyObject {
    func viewDidLoad()
    func saveTask(taskModelDTO: TaskModelDTO?)
}

class TaskDetailPresenter {
    
    //MARK: - Public properties
    weak var controller: TaskDetailViewControllerProtocol?
    
    //MARK: - Private properties
    private var router: TaskDetailRouterProtocol?
    private var cellService: TaskDelegateService
    
    //MARK: - Init
    init(controller: TaskDetailViewControllerProtocol, router: TaskDetailRouterProtocol, cellService: TaskDelegateService) {
        self.controller = controller
        self.router = router
        self.cellService = cellService
    }
}

//MARK: - Protocol
extension TaskDetailPresenter: TaskDetailPresenterProtocol {
    func viewDidLoad() {
        let item = cellService.taskModelDTO
        controller?.configure(with: item)
    }
    
    func saveTask(taskModelDTO: TaskModelDTO?) {
        if let taskModelDTO = taskModelDTO {
            cellService.closure(taskModelDTO)
            router?.closeView()
        } else {
            router?.closeView()
        }
    }
}
