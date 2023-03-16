//
//  HeaderView.swift
//  TODO
//
//  Created by Artem Vavilov on 08.03.2023.
//

import UIKit
import TinyConstraints

final class HeaderView: UIView {
    
    //MARK: - Public properties
    var buttonAction: (() -> (Void))?
    
    //MARK: - Private properties
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
        stack.spacing = 2
       return stack
    }()
    private let progressLabel = UILabel()
    private let progressBar: UIProgressView = {
        let bar = UIProgressView(progressViewStyle: .bar)
        bar.trackTintColor = .systemGray
        bar.progressTintColor = .tintColor
        return bar
    }()
    
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
        verticalstack.edgesToSuperview(insets: .left(8) + .right(8))
        horisontalstack.edgesToSuperview()
        button.edgesToSuperview()
        
        photoView.widthToHeight(of: photoView)
        photoView.height(UIScreen.main.bounds.width / 5)
        
        progressBar.heightAnchor.constraint(equalToConstant: 10).isActive = true
    }
    
    private func setupViews() {
        backgroundColor = .clear
        
        photoView.backgroundColor = .red
        photoView.layer.cornerRadius = UIScreen.main.bounds.width / 10
        photoView.layer.masksToBounds = true
        
        nameLabel.text = "Vava"
        nameLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        nameLabel.textAlignment = .right
        
        progressLabel.font = .systemFont(ofSize: 64, weight: .heavy)
        progressLabel.textAlignment = .center
        
        progressBar.layer.cornerRadius = 5
        progressBar.clipsToBounds = true
        
        button.setTitle("Button", for: .normal)
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
    
    //MARK: - @objc
    @objc
    private func buttonDidTapped() {
        buttonAction?()
    }
    
    //MARK: - Public func
    func updateProgress(_ float: Float) {
        if float.isNaN { return }
        let labelText = "\(Int(float * 100))%"
        setProgressLabel(labelText)
        setProgressBar(float)
    }
}
