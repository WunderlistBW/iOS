//
//  WunderlistTests.swift
//  WunderlistTests
//
//  Created by Chris Dobek on 6/22/20.
//  Copyright © 2020 Wunderlist. All rights reserved.
//

import XCTest
import CoreData
import Foundation
@testable import Wunderlist

class WunderlistTests: XCTestCase {
    var storageManager: StorageManager?
    var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        return managedObjectModel
    }()
    lazy var mockPersistantContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "CoreDataUnitTesting", managedObjectModel: self.managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { description, error in
           XCTAssertNil(error)
        }
        return container
    }()

    override func setUp() {
        super.setUp()
        storageManager = StorageManager(container: mockPersistantContainer)
    }
    
    override func tearDown() {
        super.tearDown()
        storageManager = nil
    }
    
    func testNESignUp() {
        let login = NEUserController()
        let expectation = self.expectation(description: "Waiting for signing up to be completed")
        login.signUp(with: "Chris", password: "12345") { error in
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
        let newListEntry = ListEntry(name: "newEntry",                                                                   dueDate: dueDate,
                                     isComplete: false,
                                     context: testDataStack.mainContext)
        XCTAssertNotNil(newListEntry)
    }
    func testSaveAndLoadListEntryObject() {
        let testDataStack = CoreDataStack()
        let testFRC = testDataStack.fetchedResultsController
        testDataStack.mainContext.reset()
        XCTAssertEqual(testFRC.fetchedObjects?.count, 0)
        let dueDate = Date(timeIntervalSinceNow: 100)
        let newListEntry = ListEntry(name: "newEntry",
                                     dueDate: dueDate,
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
        XCTAssertEqual(testFRC.fetchedObjects?.count, 0)
        let dueDate = Date(timeIntervalSinceNow: 100)
        let newListEntry = ListEntry(name: "newEntry",
                                     dueDate: dueDate,
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
                                     dueDate: dueDate,
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
