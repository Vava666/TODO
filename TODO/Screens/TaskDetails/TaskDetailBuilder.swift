//
//  TaskDetailBuilder.swift
//  TODO
//
//  Created by Artem Vavilov on 03.03.2023.
//

import UIKit

class TaskDetailBuilder {
    static func build(cellService: TaskDelegateService) -> UIViewController {
        let viewController = TaskDetailViewController()
        let router = TaskDetailRouter(viewController: viewController)
        let presenter = TaskDetailPresenter(controller: viewController, router: router, cellService: cellService)
        viewController.presenter = presenter
        return viewController
    }
}
