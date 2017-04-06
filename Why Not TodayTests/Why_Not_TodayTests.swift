//
//  Why_Not_TodayTests.swift
//  Why Not TodayTests
//
//  Created by Taylor Ray Howard on 3/19/17.
//  Copyright (c) 2017 TaylorRayHoward. All rights reserved.
//

import XCTest
@testable import Why_Not_Today
import RealmSwift

class Why_Not_TodayTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testArrays() {
        let habits = ["This", "Is", "A", "Test"]
        XCTAssert(habits[0] == "This")
    }

    func testHabitAttributes() {
        let habit1 = Habit()
        let habit2 = Habit()
        habit1.name = "Foo"
        habit1.type = "Bar"
        habit2.name = "Foo"
        habit2.type = "Bar"
        XCTAssertEqual(habit1.name, habit2.name)
        XCTAssertEqual(habit1.type, habit2.type)
    }

    func testRealmAdd() {
        let realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "TestRealm"))
        let habit = Habit()
        let topRange = 5
        for x in 0..<topRange {
            let habit = Habit()
            habit.name = String(x)
            habit.type = String(x)
            try! realm.write {
                realm.add(habit)
            }
        }
        var habits = realm.objects(Habit.self)
        XCTAssertEqual(habits.count, topRange)
        habits = realm.objects(Habit.self).filter("name == '1'")
        XCTAssertEqual(habits.count, 1)
    }

    func testRealmDelete() {
        let realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "TestRealm"))
        let habit = Habit()
        habit.name = "foo"
        habit.type = "bar"

        try! realm.write{
            realm.add(habit)
        }

        let deleteHabit = realm.objects(Habit.self).filter("name == 'foo'")
        try! realm.write {
            realm.delete(deleteHabit)
        }

        let habits = realm.objects(Habit.self)
        XCTAssertEqual(habits.count, 0)
    }

}
