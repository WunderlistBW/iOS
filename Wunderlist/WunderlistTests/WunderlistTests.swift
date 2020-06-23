//
//  WunderlistTests.swift
//  WunderlistTests
//
//  Created by Chris Dobek on 6/22/20.
//  Copyright © 2020 Wunderlist. All rights reserved.
//

import XCTest
@testable import Wunderlist

class WunderlistTests: XCTestCase {
    func testNESignUp() {
        let login = NEUserController()
        let expectation = self.expectation(description: "Waiting for signing up to be completed")
        login.signUp(with: "Chris", password: "12345", email: "chris@gmail.com", name: "Chris") { error in
            guard error == error else {
                NSLog("Error signing up: \(error)")
                return
            }
            XCTAssertNoThrow(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    func testNESignIn() {
        let login = NEUserController()
        let expectation = self.expectation(description: "Waiting for signing in to be completed")
        login.signIn(with: "Chris", password: "12345") { (error) in
            guard error == error else {
                NSLog("Error signing in :\(error)")
                return
            }
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
        XCTAssertNotNil(login.bearer)
    }
    func testCreateListEntryObject() {
        let testDataStack = CoreDataStack()
        let dueDate = Date(timeIntervalSinceNow: 100)
        let newListEntry = ListEntry(name: "newEntry",
                                     listId: Int64.random(in: 0...1000),
                                     dueDate: dueDate,
                                     isRecurring: false,
                                     dayOfWeek: 2,
                                     isComplete: false,
                                     context: testDataStack.mainContext)
        XCTAssertNotNil(newListEntry)
    }
    func testSaveAndLoadListEntryObject() {
        let testDataStack = CoreDataStack()
        let testFRC = testDataStack.fetchedResultsController
        XCTAssertNil(testFRC.fetchedObjects)
        let dueDate = Date(timeIntervalSinceNow: 100)
        let newListEntry = ListEntry(name: "newEntry",
                                     listId: Int64.random(in: 0...1000),
                                     dueDate: dueDate,
                                     isRecurring: false,
                                     dayOfWeek: 2,
                                     isComplete: false,
                                     context: testDataStack.mainContext)
        XCTAssertNotNil(newListEntry)
        XCTAssertNoThrow(try testDataStack.mainContext.save())
        XCTAssertNotNil(testFRC.fetchedObjects)
        XCTAssertEqual(testFRC.fetchedObjects?.count, 1)
        XCTAssertEqual(testFRC.fetchedObjects?[0].name, "newEntry")
    }
    func testDeleteListEntryObject() {
        let testDataStack = CoreDataStack()
        let testFRC = testDataStack.fetchedResultsController
        XCTAssertNil(testFRC.fetchedObjects)
        let dueDate = Date(timeIntervalSinceNow: 100)
        let newListEntry = ListEntry(name: "newEntry",
                                     listId: Int64.random(in: 0...1000),
                                     dueDate: dueDate,
                                     isRecurring: false,
                                     dayOfWeek: 2,
                                     isComplete: false,
                                     context: testDataStack.mainContext)
        XCTAssertNotNil(newListEntry)
        XCTAssertNoThrow(try testDataStack.mainContext.save())
        XCTAssertNotNil(testFRC.fetchedObjects)
        XCTAssertEqual(testFRC.fetchedObjects?.count, 1)
        testDataStack.mainContext.delete(newListEntry!)
        XCTAssertNoThrow(try testDataStack.mainContext.save())
        XCTAssertNil(testFRC.fetchedObjects)
    }
    func testListEntryCompletes() {
        let testDataStack = CoreDataStack()
        let interval: TimeInterval = 30
        let dueDate = Date(timeIntervalSinceNow: interval)
        let letComplete = expectation(description: "Wait for ListEntry to complete.")
        let newListEntry = ListEntry(name: "newEntry",
                                     listId: Int64.random(in: 0...1000),
                                     dueDate: dueDate,
                                     isRecurring: false,
                                     dayOfWeek: 2,
                                     isComplete: false,
                                     context: testDataStack.mainContext)
        XCTAssertNotNil(newListEntry)
        XCTAssertEqual(newListEntry?.isComplete, false)
        wait(for: [letComplete], timeout: 40)
        XCTAssertEqual(newListEntry?.isComplete, true)
    }
    func testSortListEntryObjectsByDate() {
    }
    func testSortListEntryObjectsByCompleted() {
    }
}
