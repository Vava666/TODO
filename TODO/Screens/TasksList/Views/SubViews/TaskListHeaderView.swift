//
//  TaskListHeaderView.swift
//  TODO
//
//  Created by Artem Vavilov on 08.03.2023.
//

import UIKit
import TinyConstraints

final class TaskListHeaderView: UIView {
    
    //MARK: - Public properties
    var buttonAction: (() -> (Void))?
    
    //MARK: - Private properties
    private let backView = UIView()
    private let horisontalstack: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .leading
        stack.axis = .horizontal
       return stack
    }()
    private let photoView = UIImageView()
    private let nameLabel = UILabel()
    private let button = UIButton()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    //MARK: - Private func
    private func setup() {
        addSubviews()
        addArrangedSubviews()
        setupConstraints()
        setupViews()
        setupButtons()
    }
    
    private func addSubviews() {
        addSubview(backView)
        backView.addSubview(horisontalstack)
        backView.addSubview(button)
    }
    
    private func addArrangedSubviews() {
        [photoView, nameLabel].forEach {
            horisontalstack.addArrangedSubview($0)
        }
    }
    
    private func setupConstraints() {
        backView.edgesToSuperview()
        horisontalstack.edgesToSuperview(insets: .left(8) + .right(32))
        button.edgesToSuperview()
        
        photoView.widthToHeight(of: photoView)
        photoView.height(UIScreen.main.bounds.width / 8)
    }
    
    private func setupViews() {
        backgroundColor = .clear
        
        photoView.backgroundColor = .red
        photoView.layer.cornerRadius = UIScreen.main.bounds.width / 16
        photoView.layer.masksToBounds = true
        
        nameLabel.text = ""
        nameLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        nameLabel.textAlignment = .right
    }
    
    private func setupButtons() {
        button.addTarget(self, action: #selector(buttonDidTapped), for: .touchUpInside)
    }
    
    //MARK: - @objc
    @objc
    private func buttonDidTapped() {
        buttonAction?()
    }
    
    //MARK: - Public func
    func configure(with profileModel: ProfileModel) {
        nameLabel.text = profileModel.name
    }
}
