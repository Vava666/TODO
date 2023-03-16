//
//  TableCellView.swift
//  TODO
//
//  Created by Artem Vavilov on 12.03.2023.
//

import UIKit
import TinyConstraints

class TaskListCellView: UITableViewCell {
    
    //MARK: - Properties
    private let backView = UIView()
    private let label = UILabel()
    private let dateLabel = UILabel()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    //MARK: - lifecycle
    override func prepareForReuse() {
        label.text = ""
        dateLabel.text = ""
    }
    
    //MARK: - private func
    private func setup() {
        addSubviews()
        setupConstraints()
        setupViews()
    }
    
    private func addSubviews() {
        contentView.addSubview(backView)
        backView.addSubview(label)
        backView.addSubview(dateLabel)
    }
    
    private func setupConstraints() {
        backView.edgesToSuperview()
        label.edgesToSuperview(excluding: .trailing, insets: .left(12) + .right(3) + .top(3) + .bottom(3))
        dateLabel.edgesToSuperview(excluding: .leading, insets: .left(3) + .right(12) + .top(3) + .bottom(3))
        label.leadingToTrailing(of: dateLabel)
        
    }
    
    private func setupViews() {
        label.font = .systemFont(ofSize: 24)
        dateLabel.font = .systemFont(ofSize: 24)
    }
    
    //MARK: - Config
    func configure(with taskListModelDTO: TaskListModelDTO) {
        label.text = taskListModelDTO.name
        if let date = taskListModelDTO.getMaxDate() {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMM, YY"
            dateLabel.text = dateFormatter.string(from: date)
        }
    }
}
