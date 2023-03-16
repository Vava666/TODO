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

//MARK: - Profile
struct ProfileModel: Codable {
    var name: String?
    var imageURL: String?
//    let color: Colors
    
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case imageURL = "imageURL"
    }
    
    init() {
        self.name = ""
        self.imageURL = ""
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try? container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.imageURL = try? container.decodeIfPresent(String.self, forKey: .imageURL) ?? ""
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

struct ProfileService {
    var profileModel: ProfileModel?
    let closure: (ProfileModel) -> (Void)
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
