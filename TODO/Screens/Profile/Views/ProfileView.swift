//
//  ProfileView.swift
//  TODO
//
//  Created by Artem Vavilov on 16.03.2023.
//

import UIKit
import TinyConstraints

final class ProfileView: UIView {
    
    var closure: ((ProfileModel)->(Void))?
    
    private let backView = UIView()
    private let content = UIView()
    private let image = UIImageView()
    private let vStack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.spacing = 2
        stack.axis = .vertical
        return stack
    }()
    private let name = UITextField()
    private let label = UILabel()
    private let colorStack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.spacing = 2
        stack.axis = .horizontal
        return stack
    }()
    private let saveButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setup() {
        addSubviews()
        addArrangedSubviews()
        setupConstraints()
        setupViews()
        setupButtons()
    }
    
    private func addSubviews() {
        addSubview(backView)
        backView.addSubview(content)
        [image, vStack, saveButton].forEach({ content.addSubview($0) })
    }
    
    private func addArrangedSubviews() {
        vStack.addArrangedSubview(name)
        vStack.addArrangedSubview(label)
        vStack.addArrangedSubview(colorStack)
    }
    
    private func setupConstraints() {
        backView.edgesToSuperview(usingSafeArea: true)
        content.edgesToSuperview(excluding: .top)
        content.heightToSuperview(multiplier: 0.4)
        
        image.centerXToSuperview()
        image.topToSuperview(offset: 6)
        image.height(Constants.width / 5)
        image.widthToHeight(of: image)
        
        vStack.leadingToSuperview(offset: 16)
        vStack.trailingToSuperview(offset: -16)
        vStack.topToBottom(of: image)
        vStack.bottomToTop(of: saveButton)
        
        saveButton.centerXToSuperview()
        saveButton.bottomToSuperview(offset: -16)
        saveButton.height(Constants.width / 7)
        saveButton.width(Constants.width - 16)
    }
    
    private func setupViews() {
        backView.backgroundColor = .clear
        content.backgroundColor = ColorsInter.background
        content.layer.cornerRadius = 32
        content.clipsToBounds = true
        
        image.backgroundColor = .red
        image.layer.cornerRadius = Constants.width / 10
        image.clipsToBounds = true
        
        name.font = .systemFont(ofSize: 24, weight: .semibold)
        name.placeholder = "Enter name"
        
        label.text = "choose your favorite color"
        label.font = .systemFont(ofSize: 18)
        label.textColor = .systemGray
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.backgroundColor = .systemBlue
        saveButton.layer.cornerRadius = 24
        saveButton.clipsToBounds = true
    }
    
    private func setupButtons() {
        saveButton.addTarget(self, action: #selector(saveDidTapped), for: .touchUpInside)
    }
    
    @objc
    func saveDidTapped() {
        var profileModel = ProfileModel()
        profileModel.name = name.text ?? ""
        closure?(profileModel)
    }
    
    func configure(with profileModel: ProfileModel) {
        name.text = profileModel.name
    }
}

extension ProfileView {
    enum Constants {
        static let width = UIScreen.main.bounds.width
    }
}