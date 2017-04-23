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
                let habit1 = Habit(n: "Foo", t: "")
                let habit2 = Habit(n: "Foo", t: "")
                expect(habit1.name).to(equal(habit2.name))
            }
            it("has a type property") {
                let habit1 = Habit(n: "", t: "Bar")
                let habit2 = Habit(n: "", t: "Bar")
                expect(habit1.name).to(equal(habit2.name))
            }
            it("has a dates completed property that keeps track of days successfully/unsuccessfully completed") {
                let habit = Habit()
                let dateCompleted = DateCompleted()
                dateCompleted.dateCompleted = Date()
                dateCompleted.successfullyCompleted = true
                habit.datesCompleted.append(dateCompleted)
                expect(habit.datesCompleted[0].dateCompleted.numberDayFromDate()).to(equal(Date().numberDayFromDate()))
            }
        }
        describe("The realm database has database features") {
            
            it("can save a habit object") {
                let habit = Habit(n: "Foo", t: "Bar")
                
                DBHelper.testInstance.writeObject(objects: [habit])
                let habits = DBHelper.testInstance.getAll(ofType: Habit.self)
                
                expect(habits.count).to(equal(1))
            }

            it("can delete a habit object") {
                let habit = Habit(n: "Foo", t: "Bar")
                DBHelper.testInstance.writeObject(objects: [habit])

                var habits = DBHelper.testInstance.getAll(ofType: Habit.self)

                DBHelper.testInstance.deleteAll(ofType: Habit.self)
                habits = DBHelper.testInstance.getAll(ofType: Habit.self)

                expect(habits.count).to(equal(0))
            }
            it("can query") {
                var habit = Habit(n: "Foo", t: "Bar")
                
                DBHelper.testInstance.writeObject(objects: [habit])
                habit = Habit(n: "FooBar", t: "BarFoo")

                DBHelper.testInstance.writeObject(objects: [habit])

                let habits = DBHelper.testInstance.getAll(ofType: Habit.self).filter("name == 'Foo'")
                expect(habits.count).to(equal(1))
            }
            it("can update") {
                var habit = Habit(n: "Foe", t: "Bear")
                DBHelper.testInstance.writeObject(objects: [habit])

                habit = DBHelper.testInstance.getAll(ofType: Habit.self).filter("name == 'Foe' AND type == 'Bear'").first! as! Habit

                DBHelper.testInstance.updateHabit(habit, name: "Foo", type: "Bar")

                habit = DBHelper.testInstance.getAll(ofType: Habit.self).filter("name == 'Foo' AND type == 'Bar'").first! as! Habit
                expect(habit.name).to(equal("Foo"))
                expect(habit.type).to(equal("Bar"))
            }
            it("returns nothing when there is a bad filter") {
                let habit = Habit(n: "Foo", t: "Bar")
                DBHelper.testInstance.writeObject(objects: [habit])
                
                let emptyHabit = DBHelper.testInstance.getAll(ofType: Habit.self).filter("name == 'abc'").first as? Habit
                expect(emptyHabit).to(beNil())
            }
            
            pending("will delete the habit and the dates competed of that habit") {
                
            }
        }
    }
}

