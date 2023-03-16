//
//  CellView.swift
//  TODO
//
//  Created by Artem Vavilov on 02.03.2023.
//

import UIKit
import TinyConstraints

final class EmptyCellView: UICollectionViewCell {
    
    //MARK: - Private properties
    private let backView = UIView()
    private let label = UILabel()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    //MARK: - Private func
    private func setup() {
        addSubviews()
        setupConstraints()
        setupView()
    }
    
    private func addSubviews() {
        addSubview(backView)
        backView.addSubview(label)
    }
    
    private func setupConstraints() {
        backView.edgesToSuperview()
        label.centerInSuperview()
    }
    
    private func setupView() {
        backgroundColor = .clear
        
        backView.layer.cornerRadius = 24
        backView.backgroundColor = .lightGray
        
        label.text = "add task"
    }
}
