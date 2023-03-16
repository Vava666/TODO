//
//  TaskDetailViewController.swift
//  TODO
//
//  Created by Artem Vavilov on 03.03.2023.
//

import UIKit
import TinyConstraints

//MARK: - Protocols
protocol TaskDetailViewControllerProtocol: AnyObject {
    func configure(with task: TaskModelDTO)
}

class TaskDetailViewController: UIViewController {
    
    //MARK: - Public properties
    var presenter: TaskDetailPresenter?
    
    //MARK: - Private properties
    private let taskView = TaskDetailView()
    
    //MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    //MARK: - Private func
    private func setup() {
        addSubviews()
        setupConstrains()
        setupView()
        setupObservers()
    }
    
    private func addSubviews() {
        view.addSubview(taskView)
    }
    
    private func setupConstrains() {
        taskView.edgesToSuperview()
    }
    
    private func setupView() {
        view.backgroundColor = .clear
        
        taskView.saveClosure = { [weak self] taskModelDTO in
            self?.presenter?.saveTask(taskModelDTO: taskModelDTO)
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

//MARK: - Protocol
extension TaskDetailViewController: TaskDetailViewControllerProtocol {
    func configure(with task: TaskModelDTO) {
        taskView.taskModelDTO = task
    }
}
