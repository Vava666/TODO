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
        setupObservers()
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
    
    //MARK: - Observers
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - @obj
    @objc
    private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            if view.frame.origin.y == .zero {
                view.frame.origin.y -= keyboardHeight
            }
        }
    }
    
    @objc
    private func keyboardWillHide() {
        view.frame.origin.y = .zero
    }
}

extension ProfileViewController: ProfileViewControllerProtocol {
    func loadProfile(profileModel: ProfileModel) {
        profileView.configure(with: profileModel)
    }
}
