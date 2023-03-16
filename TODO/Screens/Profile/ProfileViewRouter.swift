//
//  ProfileViewRouter.swift
//  TODO
//
//  Created by Artem Vavilov on 16.03.2023.
//

import UIKit

protocol ProfileViewRouterProtocol {
    func closeView()
}

class ProfileViewRouter {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

extension ProfileViewRouter: ProfileViewRouterProtocol {
    func closeView() {
        viewController?.dismiss(animated: true)
    }
}
