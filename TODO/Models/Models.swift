//
//  Resourses.swift
//  TODO
//
//  Created by Artem Vavilov on 03.03.2023.
//

import Foundation

//MARK: - CellModel
struct CellModel {
    let type: CellType
//    color
    init(type: CellType) {
        self.type = type
    }
}

extension CellModel: Comparable {
    static func < (lhs: CellModel, rhs: CellModel) -> Bool {
        switch lhs.type {
        case .task(let ltask):
            switch rhs.type {
            case .task(let rtask):
                if ltask.condition == .closed {
                    return false
                } else {
                    if rtask.condition == .closed {
                        return true
                    } else {
                        return ltask.date < rtask.date
                    }
                }
            case .empty:
                return false
            }
        case .empty:
            return false
        }
    }
    
    static func == (lhs: CellModel, rhs: CellModel) -> Bool {
        switch (lhs.type, rhs.type) {
        case (.empty, .empty):
            return true
        default : return false
        }
    }
}

//MARK: - Delegates
struct TaskDelegateService {
    let taskModelDTO: TaskModelDTO
    let closure: (TaskModelDTO) -> (Void)
}

struct TaskListDelegateService {
    let taskListModelDTO: TaskListModelDTO
    let closure: (UUID) -> (Void)
}

//MARK: - Enums
enum CellType {    
    case task(TaskModelDTO)
    case empty
}

enum TaskCondition: Int {
    case new = 0
    case closed = 1
}
