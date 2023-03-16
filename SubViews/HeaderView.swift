//
//  HeaderView.swift
//  TODO
//
//  Created by Artem Vavilov on 08.03.2023.
//

import UIKit
import TinyConstraints

final class HeaderView: UIView {
    
    var buttonAction: (() -> (Void))?
    private let backView = UIView()
    private let backStackView = UIView()
    private let horisontalstack: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .leading
        stack.axis = .horizontal
       return stack
    }()
    private let photoView = UIImageView()
    private let nameLabel = UILabel()
    private let button = UIButton()
    private let verticalstack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
       return stack
    }()
    private let progressLabel = UILabel()
    private let progressBar = UIProgressView()
    
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
        backView.addSubview(verticalstack)
        backStackView.addSubview(horisontalstack)
        backStackView.addSubview(button)
    }
    
    private func addArrangedSubviews() {
        [backStackView, progressLabel, progressBar].forEach {
            verticalstack.addArrangedSubview($0)
        }
        
        [photoView, nameLabel].forEach {
            horisontalstack.addArrangedSubview($0)
        }
    }
    
    private func setupConstraints() {
        backView.edgesToSuperview()
        verticalstack.edgesToSuperview()
        horisontalstack.edgesToSuperview()
        button.edgesToSuperview()
        
        photoView.widthToHeight(of: photoView)
        photoView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4).isActive = true
        
        progressBar.heightAnchor.constraint(equalToConstant: 10).isActive = true
    }
    
    private func setupViews() {
        backgroundColor = .clear
        photoView.backgroundColor = .red
        progressLabel.backgroundColor = .blue
        
        progressBar.progressTintColor = .black
        progressBar.trackTintColor = .lightGray
        
        nameLabel.text = "Vava"
        progressLabel.text = "100%"
        button.setTitle("Button", for: .normal)
        
        progressBar.setProgress(0.7, animated: true)
    }
    
    private func setupButtons() {
        button.addTarget(self, action: #selector(buttonDidTapped), for: .touchUpInside)
    }
    
    private func setProgressLabel(_ text: String) {
        progressLabel.text = text
    }
    
    private func setProgressBar(_ float: Float) {
        progressBar.setProgress(float, animated: true)
    }
    
    @objc
    private func buttonDidTapped() {
        buttonAction?()
    }
    
    func updateProgress(_ float: Float) {
        let labelText = "\(Int(float * 100))%"
        setProgressLabel(labelText)
        setProgressBar(float)
    }
}
