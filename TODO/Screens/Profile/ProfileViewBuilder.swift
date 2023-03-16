//
//  ProfileViewBuilder.swift
//  TODO
//
//  Created by Artem Vavilov on 16.03.2023.
//

import UIKit

final class ProfileViewBuilder {
    static func build(profileService: ProfileService) -> UIViewController {
        let controller = ProfileViewController()
        let router = ProfileViewRouter(viewController: controller)
        let presenter = ProfileViewPresenter(viewController: controller, router: router, profileService: profileService)
        controller.presenter = presenter
        return controller
    }
}
