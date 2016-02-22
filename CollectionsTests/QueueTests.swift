//
//  QueueTests.swift
//  Collections
//
//  Created by José Massada on 24/01/2016.
//  Copyright © 2016 José Massada. All rights reserved.
//

import XCTest
@testable import Collections

class QueueTests : XCTestCase {
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func testInitialises() {
    let queue = Queue<Int>()
    
    XCTAssertTrue(queue.isEmpty)
    XCTAssertEqual(0, queue.count)
    XCTAssertEqual(nil, queue.front)
  }
  
  func testInitialisesFromEmptyArrayLiteral() {
    let queue: Queue<Int> = []
    
    XCTAssertTrue(queue.isEmpty)
    XCTAssertEqual(0, queue.count)
    XCTAssertEqual(nil, queue.front)
  }
  
  func testInitialisesFromArrayLiteral() {
    let queue: Queue<Int> = [1, 2, 3]
    
    XCTAssertFalse(queue.isEmpty)
    XCTAssertEqual(3, queue.count)
    XCTAssertEqual(1, queue.front)
    
    for (i, element) in queue.enumerate() {
      XCTAssertEqual(i + 1, element)
    }
  }
  
  func testInitialisesFromEmptySequence() {
    let queue = Queue<Int>([])
    
    XCTAssertTrue(queue.isEmpty)
    XCTAssertEqual(0, queue.count)
    XCTAssertEqual(nil, queue.front)
  }
  
  func testInitialisesFromSequence() {
    let queue = Queue<Int>([1, 2, 3])
    
    XCTAssertFalse(queue.isEmpty)
    XCTAssertEqual(3, queue.count)
    XCTAssertEqual(1, queue.front)
    
    for (i, element) in queue.enumerate() {
      XCTAssertEqual(i + 1, element)
    }
  }
  
  func testClears() {
    var queue: Queue = [1, 2, 3]
    
    queue.clear()
    XCTAssertTrue(queue.isEmpty)
    XCTAssertEqual(0, queue.count)
    XCTAssertEqual(nil, queue.front)
    
    for (i, element) in queue.enumerate() {
      XCTAssertEqual(3 - i, element)
    }
  }
  
  func testPushesElement() {
    var queue: Queue<Int> = []
    
    queue.enqueue(1)
    XCTAssertFalse(queue.isEmpty)
    XCTAssertEqual(1, queue.count)
    XCTAssertEqual(1, queue.front)
  }
  
  func testPushesElements() {
    var queue: Queue<Int> = []
    
    queue.enqueue(1)
    queue.enqueue(2)
    queue.enqueue(3)
    
    XCTAssertFalse(queue.isEmpty)
    XCTAssertEqual(3, queue.count)
    XCTAssertEqual(1, queue.front)
    
    for (i, element) in queue.enumerate() {
      XCTAssertEqual(i + 1, element)
    }
  }
  
  func testPopsElement() {
    var queue: Queue = [1]
    
    XCTAssertEqual(1, queue.dequeue())
    
    XCTAssertTrue(queue.isEmpty)
    XCTAssertEqual(0, queue.count)
    XCTAssertEqual(nil, queue.front)
  }
  
  func testPopsElements() {
    var queue: Queue = [1, 2, 3]
    
    XCTAssertEqual(1, queue.dequeue())
    XCTAssertEqual(2, queue.dequeue())
    XCTAssertEqual(3, queue.dequeue())
    
    XCTAssertTrue(queue.isEmpty)
    XCTAssertEqual(0, queue.count)
    XCTAssertEqual(nil, queue.front)
  }
  
  func testEquals() {
    XCTAssertTrue(Queue<Int>() == [])
    XCTAssertTrue([] == Queue<Int>([]))
    XCTAssertTrue(Queue<Int>() == Queue<Int>([]))
    
    let queue: Queue = [1, 2, 3]
    var anotherQueue: Queue = [1, 2]
    XCTAssertTrue(queue != anotherQueue)
    
    anotherQueue.enqueue(3)
    XCTAssertTrue(queue == anotherQueue)
  }
  
  func testPushingPerformance() {
    var queue = Queue<Int>()
    
    measureBlock {
      for i in 0..<100_000 {
        queue.enqueue(i)
      }
    }
  }
  
  func testPushingPoppingPerformance() {
    var queue = Queue<Int>()
    
    measureBlock {
      for i in 0..<100_000 {
        queue.enqueue(i)
        XCTAssertEqual(i, queue.dequeue())
      }
    }
  }
  
  func testGetsDescriptions() {
    var queue: Queue<Int> = []
    XCTAssertEqual(queue.description, "[]")
    XCTAssertEqual(queue.debugDescription, "Queue([])")
    
    queue = [1, 2]
    XCTAssertEqual(queue.description, "[1, 2]")
    XCTAssertEqual(queue.debugDescription, "Queue([1, 2])")
  }
}
