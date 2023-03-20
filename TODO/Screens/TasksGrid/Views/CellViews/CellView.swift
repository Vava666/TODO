//
//  CellView.swift
//  TODO
//
//  Created by Artem Vavilov on 02.03.2023.
//

import UIKit
import TinyConstraints

final class CellView: UICollectionViewCell {
    
    //MARK: - Private properties
    private let backView = UIView()
    private let horisontalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 2
        return stack
    }()
    private let dateView = DateCellView()
    private let checkView = UIImageView()
    private let taskDescription = UILabel()
    private var mainColor: UIColor = Colors.blue.color
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    //MARK: - Lifecycle
    override func prepareForReuse() {
        taskDescription.text = ""
        dateView.date = nil
    }
    
    //MARK: - Private func
    private func setup() {
        addSubviews()
        setupConstraints()
        setupView()
    }
    
    private func addSubviews() {
        addSubview(backView)
        backView.addSubview(horisontalStack)
        backView.addSubview(taskDescription)
        horisontalStack.addArrangedSubview(dateView)
        horisontalStack.addArrangedSubview(checkView)
    }
    
    private func setupConstraints() {
        backView.edgesToSuperview()
        
        horisontalStack.centerXToSuperview()
        horisontalStack.topToSuperview()
        horisontalStack.leadingToSuperview()
        horisontalStack.trailingToSuperview()
        horisontalStack.bottomToTop(of: taskDescription)
        
        taskDescription.leadingToSuperview(offset: 6)
        taskDescription.trailingToSuperview(offset: 6)
        taskDescription.bottomToSuperview(offset: -6)
        taskDescription.heightToSuperview(multiplier: 0.60)
    }
    
    private func setupView() {
        backgroundColor = .clear
        layer.cornerRadius = 24
        clipsToBounds = true
        
        taskDescription.textAlignment = .left
        
        checkView.image = UIImage(systemName: "checkmark.circle")
        checkView.contentMode = .scaleAspectFit
    }
    
    private func closeTask(_ closed: Bool) {
        if closed {
            backView.backgroundColor = Colors.lightBlue.color
            checkView.tintColor = .systemGreen
        } else {
            backView.backgroundColor = mainColor
            checkView.tintColor = mainColor
        }
    }
    
    //MARK: - Config
    func configure(with data: TaskModelDTO, color: UIColor) {
        mainColor = color
        taskDescription.text = data.taskDescription
        dateView.date = data.date
        switch data.condition {
        case .new:
            closeTask(false)
        case .closed:
            closeTask(true)
        }
    }
}
