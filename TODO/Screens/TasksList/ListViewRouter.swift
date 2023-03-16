//
//  ListViewRouter.swift
//  TODO
//
//  Created by Artem Vavilov on 09.03.2023.
//

import UIKit

protocol ListViewRouterProtocol {
    func showDetails(taskListDelegateService: TaskListDelegateService)
}

final class ListViewRouter {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

extension ListViewRouter: ListViewRouterProtocol {
    func showDetails(taskListDelegateService: TaskListDelegateService) {
        let controller = GridViewBuilder.build(taskListDelegateService: taskListDelegateService)
        viewController?.navigationController?.pushViewController(controller, animated: true)
    }
}
