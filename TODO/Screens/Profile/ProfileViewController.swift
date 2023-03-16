//
//  ProfileController.swift
//  TODO
//
//  Created by Artem Vavilov on 16.03.2023.
//

import UIKit
import TinyConstraints

protocol ProfileViewControllerProtocol: AnyObject {
    func loadProfile(profileModel: ProfileModel)
}

final class ProfileViewController: UIViewController {
    
    var presenter: ProfileViewPresenterProtocol?
    
    private let profileView = ProfileView()
    
    override func loadView() {
        super.loadView()
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    private func setup() {
        addSubviews()
        setupConstraints()
        setupViews()
    }
    
    private func addSubviews() {
        view.addSubview(profileView)
    }
    
    private func setupConstraints() {
        profileView.edgesToSuperview()
    }
    
    private func setupViews() {
        view.backgroundColor = .clear
        
        profileView.closure = { [weak self] profileModel in
            self?.presenter?.profileDidSaved(profileModel: profileModel)
        }
    }
}

extension ProfileViewController: ProfileViewControllerProtocol {
    func loadProfile(profileModel: ProfileModel) {
        profileView.configure(with: profileModel)
    }
}
