//
//  ModelsDTO.swift
//  TODO
//
//  Created by Artem Vavilov on 07.03.2023.
//

import Foundation

//MARK: - TaskModelDTO
struct TaskModelDTO {
    let id: UUID
    let taskDescription: String
    let alarmOn: Bool
    let date: Date
    let condition: TaskCondition
    
    init(taskDescription: String, alarmOn: Bool, date: Date, condition: TaskCondition) {
        self.id = UUID()
        self.taskDescription = taskDescription
        self.alarmOn = alarmOn
        self.date = date
        self.condition = condition
    }
}

extension TaskModelDTO {
    init(_ obj: TaskModel) {
        id = obj.id
        taskDescription = obj.taskDescription
        alarmOn = obj.alarmOn
        date = obj.date
        condition = obj.condition
    }
}

extension TaskModelDTO {
    init(_ dto: TaskModelDTO, taskDescription: String, alarmOn: Bool, date: Date, condition: TaskCondition) {
        id = dto.id
        self.taskDescription = taskDescription
        self.alarmOn = alarmOn
        self.date = date
        self.condition = condition
    }
}

//MARK: - TaskListModelDTO
struct TaskListModelDTO: Equatable {
    static func == (lhs: TaskListModelDTO, rhs: TaskListModelDTO) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: UUID
    let name: String
    let items: [TaskModelDTO]
    let condition: TaskCondition
    
    init(name: String) {
        self.id = UUID()
        self.name = name
        self.items = []
        self.condition = .new
    }
}

extension TaskListModelDTO {
    init (_ obj: TaskListModel) {
        id = obj.id
        name = obj.name
        items = obj.items.map({ taskModel in
            return TaskModelDTO(taskModel)
        })
        condition = obj.condition
    }
}

extension TaskListModelDTO {
    init(_ dto: TaskListModelDTO, name: String, condition: TaskCondition) {
        id = dto.id
        self.name = name
        items = dto.items
        self.condition = condition
    }
}

extension TaskListModelDTO {
    func getMaxDate() -> Date? {
        if let maxDate = items.filter({$0.condition == .new}).sorted(by: {$0.date < $1.date }).first {
            return maxDate.date
        }
        return nil
    }
}
