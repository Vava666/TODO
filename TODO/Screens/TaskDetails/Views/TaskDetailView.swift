//
//  TaskDetailView.swift
//  TODO
//
//  Created by Artem Vavilov on 03.03.2023.
//

import UIKit
import TinyConstraints

class TaskDetailView: UIView {
    
    //MARK: - Public properties
    var saveClosure: ((TaskModelDTO?) -> (Void))?
    var taskModelDTO: TaskModelDTO? {
        didSet {
            configure()
        }
    }
    
    //MARK: - Private properties
    private let backView = UIView()
    private let verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 2
        return stack
    }()
    
    private let closeButton = UIButton()
    
    private let taskText = UITextField()
    
    private let datePicker = UIDatePicker()
    private let dateLabel = UILabel()
    
    private let allertLabel = UILabel()
    private let toggle = UISwitch()
    private var swichAction: (() -> (Void))?
    
    private let someTextLabel = UILabel()
    
    private let saveButton = UIButton()
    
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
        backView.addSubview(closeButton)
        backView.addSubview(verticalStack)
        backView.addSubview(saveButton)
    }
    
    private func addArrangedSubviews() {
        verticalStack.addArrangedSubview(taskText)
        verticalStack.addArrangedSubview(createHorisontalStack(views: [dateLabel, datePicker]))
        verticalStack.addArrangedSubview(createHorisontalStack(views: [allertLabel, toggle]))
        verticalStack.addArrangedSubview(someTextLabel)
    }
    
    private func createHorisontalStack(views: [UIView]) -> UIStackView {
        let horisontalStack: UIStackView = {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.distribution = .fill
            stack.alignment = .trailing
            return stack
        }()
        views.forEach {
            horisontalStack.addArrangedSubview($0)
        }
        return horisontalStack
    }
    
    private func setupConstraints() {
        backView.leadingToSuperview()
        backView.trailingToSuperview()
        backView.bottomToSuperview(offset: -32)
        backView.heightToSuperview(multiplier: 0.45)
        
        closeButton.edgesToSuperview(excluding: .bottom, insets: .top(3))
        closeButton.height(to: backView, multiplier: 0.1)
        
        verticalStack.topToBottom(of: closeButton)
        verticalStack.leftToSuperview(offset: 32)
        verticalStack.rightToSuperview(offset: -32)
        
        saveButton.topToBottom(of: verticalStack)
        saveButton.edgesToSuperview(excluding: .top, insets: .bottom(8) + .left(8) + .right(8))
        saveButton.height(to: backView, multiplier: 0.15)
    }
    
    private func setupViews() {
        backgroundColor = .clear
        
        backView.backgroundColor = ColorsInter.background
        backView.layer.cornerRadius = 32
        backView.clipsToBounds = true
        
        closeButton.setImage(.init(systemName: "arrowshape.turn.up.backward"), for: .normal)
        closeButton.tintColor = .tintColor
        
        taskText.placeholder = "Task text"
        taskText.font = .systemFont(ofSize: 18)
        taskText.textColor = ColorsInter.textMain
        taskText.delegate = self
        taskText.returnKeyType = .done
        
        dateLabel.text = "Date:"
        dateLabel.font = .systemFont(ofSize: 18)
        dateLabel.textColor = ColorsInter.textMain
        
        datePicker.backgroundColor = ColorsInter.backgroundSub
        datePicker.timeZone = .current
        datePicker.preferredDatePickerStyle = .compact
        
        allertLabel.text = "Allert:"
        allertLabel.font = .systemFont(ofSize: 18)
        allertLabel.textColor = ColorsInter.textMain
        
        someTextLabel.text = "Toggle the switch to enable alerts"
        someTextLabel.font = .systemFont(ofSize: 14)
        someTextLabel.textColor = ColorsInter.textSub
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.backgroundColor = .systemBlue
        saveButton.layer.cornerRadius = 24
    }
    
    private func setupButtons() {
        saveButton.addTarget(self, action: #selector(didSaveTapped), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(didCloseTapped), for: .touchUpInside)
    }
    
    //MARK: - @objc
    @objc
    private func didSaveTapped() {
        guard let currentTaskModelDTO = taskModelDTO else { return }
        let newTaskModelDTO = TaskModelDTO(
            currentTaskModelDTO,
            taskDescription: taskText.text ?? "",
            alarmOn: toggle.isOn,
            date: datePicker.date,
            condition: .new
            )
        saveClosure?(newTaskModelDTO)
    }
    
    @objc
    private func didCloseTapped() {
        saveClosure?(nil)
    }
    
    //MARK: - Congig
    private func configure() {
        guard  let model = taskModelDTO else { return }
        datePicker.date = model.date
        taskText.text = model.taskDescription
        toggle.isOn = model.alarmOn
    }
}

//MARK: - Delegate
extension TaskDetailView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return false
    }
}
