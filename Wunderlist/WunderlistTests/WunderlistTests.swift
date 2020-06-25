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
    func testEmptyStore() {
        if let storageManager = self.storageManager {
            let listEntries = storageManager.fetchAll()
            XCTAssertEqual(listEntries.count, 0)
        } else {
            XCTFail("listEntries should be empty.")
        }
    }
    func testCreateListEntryObjects() {
        guard let storageManager = self.storageManager else { XCTFail("No storage manager present."); return }
        let emptyStore = storageManager.fetchAll()
        XCTAssertEqual(emptyStore.count, 0)
        for entry in 1...10 {
            XCTAssertNotNil(storageManager.insertListEntry(name: "newEntry\(entry)",
                                                           dueDate: Date() + TimeInterval(exactly: 1000)!,
                                                           listId: Int64(entry),
                                                           isComplete: false))
        }
        storageManager.save()
        let fullStore = storageManager.fetchAll()
        XCTAssertEqual(fullStore.count, 10)
    }
    func testSaveAndLoadListEntryObject() {
        guard let storageManager = self.storageManager else { XCTFail("No storage manager present."); return }
        let emptyStore = storageManager.fetchAll()
        XCTAssertEqual(emptyStore.count, 0)
        storageManager.insertListEntry(name: "testingEntry",
                                       dueDate: Date() + TimeInterval(exactly: 1000)!,
                                       listId: 6969420,
                                       isComplete: false)
        storageManager.save()
        let testContents = storageManager.fetch(name: "testingEntry")
        XCTAssertEqual(testContents.count, 1)
        XCTAssertEqual(testContents[0].name, "testingEntry")
    }
    func testDeleteListEntryObject() {
        let letFinish = expectation(description: "wait for background thread to delete.")
        guard let storageManager = self.storageManager else { XCTFail("No storage manager present."); return }
        let emptyStore = storageManager.fetchAll()
        XCTAssertEqual(emptyStore.count, 0)
        storageManager.insertListEntry(name: "testingEntry",
                                       dueDate: Date() + TimeInterval(exactly: 1000)!,
                                       listId: 6969420,
                                       isComplete: false)
        storageManager.save()
        let testContents = storageManager.fetchAll()
        XCTAssertEqual(testContents.count, 1)
        let idToDelete = testContents.first?.objectID
        guard let unwrappedId = idToDelete else { XCTFail("No ID to delete"); return }
        storageManager.remove(objectID: unwrappedId)
        letFinish.fulfill()
        wait(for: [letFinish], timeout: 3)
        storageManager.save()
        let clearedStore = storageManager.fetchAll()
        XCTAssertEqual(clearedStore.count, 0)
    }
    func testListEntryCompletes() {
        /*
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
 */
    }
    func testSortListEntryObjectsByDate() {
    }
    func testSortListEntryObjectsByCompleted() {
    }
}
