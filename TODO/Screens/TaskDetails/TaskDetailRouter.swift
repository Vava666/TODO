//
//  TaskDetailRouter.swift
//  TODO
//
//  Created by Artem Vavilov on 03.03.2023.
//

import UIKit

protocol TaskDetailRouterProtocol: AnyObject {
    func closeView()
}

class TaskDetailRouter {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

extension TaskDetailRouter: TaskDetailRouterProtocol {
    func closeView() {
        viewController?.dismiss(animated: true)
    }
}
