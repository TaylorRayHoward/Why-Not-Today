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
    
    func getAll<T>(object: T) -> Results<Object> {
        return realm.objects(object as! Object.Type)
    }
    
    
}
