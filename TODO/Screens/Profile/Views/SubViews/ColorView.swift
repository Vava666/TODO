//
//  ColorView.swift
//  TODO
//
//  Created by Artem Vavilov on 17.03.2023.
//

import UIKit

class ColorView: UIView {
    
    var closure: ((Colors) -> (Void))?
    var color: Colors? {
        didSet {
            if let color = color {
                backgroundColor = color.color
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setup() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapColor))
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc
    private func didTapColor() {
        guard let color = color else { return }
        closure?(color)
    }
}
