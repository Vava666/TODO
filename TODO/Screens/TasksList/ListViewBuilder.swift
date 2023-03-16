//
//  ListViewBuilder.swift
//  TODO
//
//  Created by Artem Vavilov on 09.03.2023.
//

import UIKit

final class ListViewBuilder {
    static func build() -> UIViewController {
        let viewController = ListViewController()
        let router = ListViewRouter(viewController: viewController)
        let presenter = ListViewPresenter(controller: viewController, router: router)
        viewController.presenter = presenter
        return viewController
    }
}
