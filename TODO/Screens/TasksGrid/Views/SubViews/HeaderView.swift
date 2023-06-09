//
//  HeaderView.swift
//  TODO
//
//  Created by Artem Vavilov on 08.03.2023.
//

import UIKit
import TinyConstraints

final class HeaderView: UIView {
    
    //MARK: - Private properties
    private let backView = UIView()
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
    }
    
    private func addSubviews() {
        addSubview(backView)
        backView.addSubview(verticalstack)
    }
    
    private func addArrangedSubviews() {
        [progressLabel, progressBar].forEach {
            verticalstack.addArrangedSubview($0)
        }
    }
    
    private func setupConstraints() {
        backView.edgesToSuperview()
        verticalstack.edgesToSuperview(insets: .left(8) + .right(8))
        
        progressBar.heightAnchor.constraint(equalToConstant: 10).isActive = true
    }
    
    private func setupViews() {
        backgroundColor = .clear
        
        progressLabel.font = .systemFont(ofSize: 64, weight: .heavy)
        progressLabel.textAlignment = .center
        
        progressBar.layer.cornerRadius = 5
        progressBar.clipsToBounds = true
    }
    
    private func setProgressLabel(_ text: String) {
        progressLabel.text = text
    }
    
    private func setProgressBar(_ float: Float) {
        progressBar.setProgress(float, animated: true)
    }
    
    //MARK: - Public func
    func updateProgress(_ float: Float) {
        if float.isNaN {
            setProgressLabel("0%")
            setProgressBar(0)
        } else {
            let labelText = "\(Int(float * 100))%"
            setProgressLabel(labelText)
            setProgressBar(float)
        }
    }
}
