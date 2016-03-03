//
// QueueTests.swift
// Collections
//
// Copyright (c) 2016 José Massada <jose.massada@gmail.com>
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
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
