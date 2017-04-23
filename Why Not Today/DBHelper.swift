//
//  DBHelper.swift
//  Why Not Today
//
//  Created by Taylor Howard on 4/23/17.
//  Copyright © 2017 TaylorRayHoward. All rights reserved.
//

import Foundation
import RealmSwift


enum Environment {
    case Application
    case Test
}

class DBHelper {
    var realm: Realm
    static let sharedInstance = DBHelper(inEnvironment: .Application)
    static let testInstance = DBHelper(inEnvironment: .Test)
    
    init(inEnvironment env: Environment) {
        if(env == .Application) {
            realm = try! Realm()
        }
        else if(env == .Test) {
            realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "TestRealm"))
        }
        else {
            realm = try! Realm()
        }
    }
    
    func getAll(ofType type: Object.Type) -> Results<Object> {
        return realm.objects(type)
    }
    
    func writeObject(objects: [Object]) {
        try! realm.write {
            for o in objects {
                realm.add(o)
            }
        }
    }
    
    func updateHabit(_ habit: Habit, name: String, type: String) {
        try! realm.write {
            habit.name = name
            habit.type = type
        }
    }
    
    func deleteAll(ofType type: Object.Type) {
        let objects = getAll(ofType: type)
        try! realm.write {
            realm.delete(objects)
        }
    }
    
    func deleteHabit(_ habit: Habit) {
        try! realm.write {
            realm.delete(habit.datesCompleted)
            realm.delete(habit)
        }
    }
}
