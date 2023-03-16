//
//  DateCellView.swift
//  TODO
//
//  Created by Artem Vavilov on 11.03.2023.
//

import UIKit

class DateCellView: UIView {
    
    //MARK: - Public properties
    var date: Date? {
        didSet {
            guard let date = date else { return }
            configure(with: date)
        }
    }
    
    //MARK: - Private properties
    private let dayLabel = UILabel()
    private let monthLabel = UILabel()
    private let timeLabel = UILabel()
    
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
        [dayLabel, monthLabel, timeLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            dayLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 3),
            dayLabel.topAnchor.constraint(equalTo: topAnchor, constant: 3),
            dayLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 3),
            dayLabel.trailingAnchor.constraint(equalTo: centerXAnchor, constant: 3),
            
            monthLabel.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 3),
            monthLabel.topAnchor.constraint(equalTo: topAnchor, constant: 3),
            monthLabel.bottomAnchor.constraint(equalTo: timeLabel.topAnchor),
            monthLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -3),
            
            timeLabel.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 3),
            timeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3),
            timeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -3),
            
        ])
    }
    
    private func setupView() {
        dayLabel.textAlignment = .center
        dayLabel.font = .systemFont(ofSize: 36, weight: .bold)
        
        monthLabel.textAlignment = .center
        monthLabel.font = .systemFont(ofSize: 12, weight: .medium)
        
        timeLabel.textAlignment = .center
        timeLabel.font = .systemFont(ofSize: 14, weight: .semibold)
    }
    
    //MARK: - Config
    private func configure(with date: Date) {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "d"
        dayLabel.text = dateFormater.string(from: date)
        dateFormater.dateFormat = "MMM"
        monthLabel.text = dateFormater.string(from: date)
        dateFormater.dateFormat = "HH:mm"
        timeLabel.text = dateFormater.string(from: date)
    }
}
