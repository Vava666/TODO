//
//  ProfileViewPresenter.swift
//  TODO
//
//  Created by Artem Vavilov on 16.03.2023.
//

import Foundation

protocol ProfileViewPresenterProtocol: AnyObject {
    func viewDidLoad()
    func profileDidSaved(profileModel: ProfileModel)
}

final class ProfileViewPresenter {
    weak var viewController: ProfileViewControllerProtocol?
    private var router: ProfileViewRouterProtocol?
    private var profileService: ProfileService
    
    private let userDefaults: UserDefaultsServiceProtocol = UserDefaultsService(with: UserDefaults.standard)
    
    init(viewController: ProfileViewControllerProtocol, router: ProfileViewRouterProtocol, profileService: ProfileService) {
        self.viewController = viewController
        self.router = router
        self.profileService = profileService
    }
    
    private func configureView(profileModel: ProfileModel) {
        viewController?.loadProfile(profileModel: profileModel)
    }
}

extension ProfileViewPresenter: ProfileViewPresenterProtocol {
    func viewDidLoad() {
        if let profileModel = profileService.profileModel {
            configureView(profileModel: profileModel)
        }
    }
    
    func profileDidSaved(profileModel: ProfileModel) {
        userDefaults.saveModel(profileModel, by: .profile)
        profileService.closure(profileModel)
        router?.closeView()
    }
}
