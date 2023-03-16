//
//  ListViewRouter.swift
//  TODO
//
//  Created by Artem Vavilov on 09.03.2023.
//

import UIKit

protocol ListViewRouterProtocol {
    func showDetails(taskListDelegateService: TaskListDelegateService)
    func showProfile(profileService: ProfileService)
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
    
    func showProfile(profileService: ProfileService) {
        let profileView = ProfileViewBuilder.build(profileService: profileService)
        viewController?.present(profileView, animated: true)
    }
}
