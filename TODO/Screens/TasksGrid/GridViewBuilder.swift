//
//  GridViewBuilder.swift
//  TODO
//
//  Created by Artem Vavilov on 02.03.2023.
//

import UIKit

final class GridViewBuilder {
    static func build(taskListDelegateService: TaskListDelegateService) -> UIViewController {
        let viewController = GridViewController()
        viewController.title = taskListDelegateService.taskListModelDTO.name
        let router = GridViewRouter(viewController: viewController)
        let presenter = GridViewPresenter(controller: viewController, router: router, taskListDelegateService: taskListDelegateService)
        viewController.presenter = presenter
        return viewController
    }
}
