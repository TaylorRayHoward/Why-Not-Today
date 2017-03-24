//
//  Why_Not_TodayTests.swift
//  Why Not TodayTests
//
//  Created by Taylor Ray Howard on 3/19/17.
//  Copyright (c) 2017 TaylorRayHoward. All rights reserved.
//

import XCTest
@testable import Why_Not_Today

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
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        var habit = Habit(context: context)
        habit.name = "Foo"
        habit.type = "Bar"
        habits.append(habit)
        XCTAssert(habits.count == 1)
        XCTAssert(habits[0].name == "Foo")
        XCTAssert(habits[0].type == "Bar")
        habit = Habit(context: context)
        habit.name = "FooBar"
        habit.type = "BarFoo"
        habits.append(habit)
        XCTAssert(habits[1].name == "FooBar")
        XCTAssertEqual(habits[1].type, "BarFoo")
    }

}
