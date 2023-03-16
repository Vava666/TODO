//
//  DatabaseModels.swift
//  TODO
//
//  Created by Artem Vavilov on 06.03.2023.
//

import RealmSwift
import Foundation

//MARK: - TaskListModel
final class TaskListModel: Object {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var name: String
    @Persisted var items: List<TaskModel>
    @Persisted private var privateCondition: Int
    var condition: TaskCondition {
        get { return TaskCondition(rawValue: privateCondition) ?? .new }
        set { privateCondition = newValue.rawValue }
    }
}

extension TaskListModel {
    convenience init(_ dto: TaskListModelDTO) {
        self.init()
        id = dto.id
        name = dto.name
        condition = dto.condition
    }
}

extension TaskListModel {
    func setCondition(_ condition: TaskCondition) {
        switch condition {
        case .new:
            privateCondition = 0
        case .closed:
            privateCondition = 1
        }
    }
}

//MARK: - TaskModel
final class TaskModel: Object {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var taskDescription: String
    @Persisted var alarmOn: Bool
    @Persisted var date: Date
    @Persisted private var privateCondition: Int
    var condition: TaskCondition {
        get { return TaskCondition(rawValue: privateCondition) ?? .new }
        set { privateCondition = newValue.rawValue }
    }
}

extension TaskModel {
    convenience init(_ dto: TaskModelDTO) {
        self.init()
        id = dto.id
        taskDescription = dto.taskDescription
        alarmOn = dto.alarmOn
        date = dto.date
        condition = dto.condition
    }
}

