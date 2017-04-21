//
//  Why_Not_TodayTests.swift
//  Why Not TodayTests
//
//  Created by Taylor Ray Howard on 3/19/17.
//  Copyright (c) 2017 TaylorRayHoward. All rights 

import Quick
import Nimble
import RealmSwift
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
            var realm: Realm!
            beforeEach {
                realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "TestRealm"))
            }
            it("can save a habit object") {
                let habit = Habit(n: "Foo", t: "Bar")
                try! realm.write {
                    realm.add(habit)
                }

                let habits = realm.objects(Habit.self)
                expect(habits.count).to(equal(1))
            }

            it("can delete a habit object") {
                let habit = Habit(n: "Foo", t: "Bar")
                try! realm.write {
                    realm.add(habit)
                }

                var habits = realm.objects(Habit.self)

                try! realm.write {
                    realm.deleteAll()
                }

                habits = realm.objects(Habit.self)

                expect(habits.count).to(equal(0))
            }
            it("can query") {
                var habit = Habit(n: "Foo", t: "Bar")
                try! realm.write {
                    realm.add(habit)
                }
                habit = Habit(n: "FooBar", t: "BarFoo")

                try! realm.write {
                    realm.add(habit)
                }

                let habits = realm.objects(Habit.self).filter("name == 'Foo'")
                expect(habits.count).to(equal(1))
            }
            it("can update") {
                var habit = Habit(n: "Foe", t: "Bear")
                try! realm.write {
                    realm.add(habit)
                }

                habit = realm.objects(Habit.self).filter("name == 'Foe' AND type == 'Bear'").first!

                try! realm.write {
                    habit.name = "Foo"
                    habit.type = "Bar"
                }

                habit = realm.objects(Habit.self).filter("name == 'Foo' AND type == 'Bar'").first!
                expect(habit.name).to(equal("Foo"))
                expect(habit.type).to(equal("Bar"))
            }
            it("returns nothing when there is a bad filter") {
                let habit = Habit(n: "Foo", t: "Bar")
                try! realm.write {
                    realm.add(habit)
                }
                
                let emptyHabit = realm.objects(Habit.self).filter("name == 'abc'").first
                expect(emptyHabit).to(beNil())
            }
        }
    }
}

