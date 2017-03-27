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
        var habits = [Habit]()
        var habit = Habit()
        habit.name = "Foo"
        habit.type = "Bar"
        habits.append(habit)
        XCTAssert(habits.count == 1)
        XCTAssert(habits[0].name == "Foo")
        XCTAssert(habits[0].type == "Bar")
        habit = Habit()
        habit.name = "FooBar"
        habit.type = "BarFoo"
        habits.append(habit)
        XCTAssert(habits[1].name == "FooBar")
        XCTAssertEqual(habits[1].type, "BarFoo")
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
