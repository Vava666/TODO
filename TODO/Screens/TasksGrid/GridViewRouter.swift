//
//  GridViewRouter.swift
//  TODO
//
//  Created by Artem Vavilov on 02.03.2023.
//

import UIKit

protocol GridViewRouterProtocol: AnyObject {
    func showDetails(cellService: TaskDelegateService)
}

final class GridViewRouter {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

extension GridViewRouter: GridViewRouterProtocol {
    func showDetails(cellService: TaskDelegateService) {
        let task = TaskDetailBuilder.build(cellService: cellService)
        viewController?.present(task, animated: true)
    }
}
