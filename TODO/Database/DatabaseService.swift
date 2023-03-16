//
//  DatabaseService.swift
//  TODO
//
//  Created by Artem Vavilov on 06.03.2023.
//

import RealmSwift
import Foundation

//MARK: - Protocol
protocol DatabaseProtocol {
    func saveObject(_ obj: Object) throws
    func saveObjects(_ objs: [Object]) throws
    func delete(_ obj: Object) throws
    func deleteAll() throws
    func getObject<T: Object>(with type: T.Type, by id: UUID) -> T?
    func getObjects<T: Object>(with type: T.Type) -> Results<T>?
    func addTaskModelToList(_ obj: TaskModel, to list: TaskListModel) throws
    func setValue<T: Any>(_ obj: Object, value: T, forKey key: String) throws
    func setCondition(_ obj: TaskListModel, condition: TaskCondition) throws
}

final class DatabaseService {
    private let realm: Realm?
    init() {
        self.realm = try? Realm()
    }
}

//MARK: - Extentions
extension DatabaseService: DatabaseProtocol {
    
    //MARK: - func for all
    func saveObject(_ obj: Object) throws {
        guard let realm else { return }
        try realm.write {
            realm.add(obj, update: .modified)
        }
    }
    
    func saveObjects(_ objs: [Object]) throws {
        try objs.forEach({
            try saveObject($0)
        })
    }
    
    func delete(_ obj: Object) throws {
        guard let realm else { return }
        try realm.write {
            realm.delete(obj)
        }
    }
    
    func deleteAll() throws {
        guard let realm else { return }
        try realm.write {
            realm.deleteAll()
        }
    }
    
    func getObjects<T: Object>(with type: T.Type) -> Results<T>? {
        guard let realm else { return nil }
        return realm.objects(type)
    }
    
    func getObject<T: Object>(with type: T.Type, by id: UUID) -> T? {
        guard let realm else { return nil}
        return realm.object(ofType: type, forPrimaryKey: id)
    }
    
    func setValue<T: Any>(_ obj: Object, value: T, forKey key: String) throws {
        guard let realm else { return }
        try realm.write {
            obj.setValue(value, forKey: key)
        }
    }
    
    //MARK: -custom functions
    func addTaskModelToList(_ obj: TaskModel, to list: TaskListModel) throws {
        guard let realm else { return }
        try realm.write {
            realm.add(obj, update: .modified)
            if !list.items.contains(obj) {
                list.items.append(obj)
            }
        }
    }
    
    func setCondition(_ obj: TaskListModel, condition: TaskCondition) throws {
        guard let realm else { return }
        try realm.write {
            obj.setCondition(condition)
        }
    }
}

//MARK: - ext func
extension Results {
    func toList<T: Object>(of type: T.Type) -> List<T> {
        let list = List<T>()
        forEach {
            list.append($0 as! T)
        }
        return list
    }
        
    func toArray() -> [Element] {
        .init(self)
    }
}
