//
//  Why_Not_TodayTests.swift
//  Why Not TodayTests
//
//  Created by Taylor Ray Howard on 3/19/17.
//  Copyright (c) 2017 TaylorRayHoward. All rights 

import Quick
import Nimble
@testable import Why_Not_Today

class HabitSpec: QuickSpec {
    override func spec() {
        describe("The habit object has multiple properties") {
            it("has a name property") {
                let habit1 = Habit(n: "Foo")
                let habit2 = Habit(n: "Foo")
                expect(habit1.name).to(equal(habit2.name))
            }
            it("has a type property") {
                let habit1 = Habit(n: "")
                let habit2 = Habit(n: "")
                expect(habit1.name).to(equal(habit2.name))
            }
            it("has a dates completed property that keeps track of days successfully/unsuccessfully completed") {
                let habit = Habit()
                let dateCompleted = DateCompleted()
                dateCompleted.dateCompleted = Date()
                dateCompleted.successfullyCompleted = true
                habit.datesCompleted.append(dateCompleted)
                expect(habit.datesCompleted[0].dateCompleted.day).to(equal(Date().day))
            }
        }
        describe("The realm database has database features") {
            afterEach {
                DBHelper.testInstance.deleteAll(ofType: Habit.self)
                DBHelper.testInstance.deleteAll(ofType: DateCompleted.self)
            }
            
            it("can save a habit object") {
                let habit = Habit(n: "Foo")
                
                DBHelper.testInstance.writeObject(objects: [habit])
                let habits = DBHelper.testInstance.getAll(ofType: Habit.self)
                
                expect(habits.count).to(equal(1))
            }

            it("can delete a habit object") {
                let habit = Habit(n: "Foo")
                DBHelper.testInstance.writeObject(objects: [habit])

                var habits = DBHelper.testInstance.getAll(ofType: Habit.self)

                DBHelper.testInstance.deleteAll(ofType: Habit.self)
                habits = DBHelper.testInstance.getAll(ofType: Habit.self)

                expect(habits.count).to(equal(0))
            }
            it("can query") {
                var habit = Habit(n: "Foo")
                
                DBHelper.testInstance.writeObject(objects: [habit])
                habit = Habit(n: "FooBar")

                DBHelper.testInstance.writeObject(objects: [habit])

                let habits = DBHelper.testInstance.getAll(ofType: Habit.self).filter("name == 'Foo'")
                expect(habits.count).to(equal(1))
            }
            it("can update") {
                var habit = Habit(n: "Foe")
                DBHelper.testInstance.writeObject(objects: [habit])

                habit = DBHelper.testInstance.getAll(ofType: Habit.self).filter("name == 'Foe'").first! as! Habit

                DBHelper.testInstance.updateHabit(habit, name: "Foo")

                habit = DBHelper.testInstance.getAll(ofType: Habit.self).filter("name == 'Foo'").first! as! Habit
                expect(habit.name).to(equal("Foo"))
            }
            it("returns nothing when there is a bad filter") {
                let habit = Habit(n: "Foo")
                DBHelper.testInstance.writeObject(objects: [habit])
                
                let emptyHabit = DBHelper.testInstance.getAll(ofType: Habit.self).filter("name == 'abc'").first as? Habit
                expect(emptyHabit).to(beNil())
            }
            
            it("will delete the habit and the dates competed of that habit") {
                var habit = Habit(n: "Foo")
                let dc = DateCompleted(dateCompleted: Date(), success: 1, for: habit)
                habit.datesCompleted.append(dc)
                DBHelper.testInstance.writeObject(objects: [habit, dc])
                
                habit = DBHelper.testInstance.getAll(ofType: Habit.self).filter("name = %@", "Foo").first! as! Habit
                expect(habit.datesCompleted.count).to(equal(1))
            }
        }
    }
}

