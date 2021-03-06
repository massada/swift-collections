//
// PriorityQueueTests.swift
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

class PriorityQueueTests : XCTestCase {
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func testInitialises() {
    let queue = PriorityQueue<Int>()
    
    XCTAssertTrue(queue.isEmpty)
    XCTAssertEqual(0, queue.count)
    XCTAssertEqual(nil, queue.front)
  }
  
  func testInitialisesWithNaturalOrdering() {
    let queue = PriorityQueue<Int>(isOrdered: <)
    
    XCTAssertTrue(queue.isEmpty)
    XCTAssertEqual(0, queue.count)
    XCTAssertEqual(nil, queue.front)
  }
  
  func testInitialisesWithNonNaturalOrdering() {
    let queue = PriorityQueue<Int>(isOrdered: >)
    
    XCTAssertTrue(queue.isEmpty)
    XCTAssertEqual(0, queue.count)
    XCTAssertEqual(nil, queue.front)
  }
  
  func testInitialisesFromEmptyArrayLiteral() {
    let queue: PriorityQueue<Int> = []
    
    XCTAssertTrue(queue.isEmpty)
    XCTAssertEqual(0, queue.count)
    XCTAssertEqual(nil, queue.front)
  }
  
  func testInitialisesFromArrayLiteral() {
    let queue: PriorityQueue<Int> = [1, 2, 3]
    
    XCTAssertFalse(queue.isEmpty)
    XCTAssertEqual(3, queue.count)
    XCTAssertEqual(1, queue.front)
    
    for (i, element) in queue.enumerated() {
      XCTAssertEqual(i + 1, element)
    }
  }
  
  func testInitialisesFromEmptySequence() {
    let queue = PriorityQueue<Int>([])
    
    XCTAssertTrue(queue.isEmpty)
    XCTAssertEqual(0, queue.count)
    XCTAssertEqual(nil, queue.front)
  }
  
  func testInitialisesFromEmptySequenceWithNaturalOrdering() {
    let queue = PriorityQueue<Int>([], isOrdered: <)
    
    XCTAssertTrue(queue.isEmpty)
    XCTAssertEqual(0, queue.count)
    XCTAssertEqual(nil, queue.front)
  }
  
  func testInitialisesFromEmptySequenceWithNonNaturalOrdering() {
    let queue = PriorityQueue<Int>([], isOrdered: >)
    
    XCTAssertTrue(queue.isEmpty)
    XCTAssertEqual(0, queue.count)
    XCTAssertEqual(nil, queue.front)
  }
  
  func testInitialisesFromSequence() {
    let queue = PriorityQueue<Int>([1, 2, 3])
    
    XCTAssertFalse(queue.isEmpty)
    XCTAssertEqual(3, queue.count)
    XCTAssertEqual(1, queue.front)
    
    for (i, element) in queue.enumerated() {
      XCTAssertEqual(i + 1, element)
    }
  }
  
  func testInitialisesFromSequenceWithNaturalOrdering() {
    let queue = PriorityQueue<Int>([1, 2, 3], isOrdered: <)
    
    XCTAssertFalse(queue.isEmpty)
    XCTAssertEqual(3, queue.count)
    XCTAssertEqual(1, queue.front)
    
    for (i, element) in queue.enumerated() {
      XCTAssertEqual(i + 1, element)
    }
  }
  
  func testInitialisesFromSequenceWithNonNaturalOrdering() {
    let queue = PriorityQueue<Int>([1, 2, 3], isOrdered: >)
    
    XCTAssertFalse(queue.isEmpty)
    XCTAssertEqual(3, queue.count)
    XCTAssertEqual(3, queue.front)
    
    for (i, element) in queue.enumerated() {
      XCTAssertEqual(3 - i, element)
    }
  }
  
  func testClears() {
    var queue: PriorityQueue = [1, 2, 3]
    
    queue.clear()
    XCTAssertTrue(queue.isEmpty)
    XCTAssertEqual(0, queue.count)
    XCTAssertEqual(nil, queue.front)
  }
  
  func testPushesElement() {
    var queue = PriorityQueue<Int>()
    
    queue.enqueue(1)
    XCTAssertFalse(queue.isEmpty)
    XCTAssertEqual(1, queue.count)
    XCTAssertEqual(1, queue.front)
  }
  
  func testPushesElements() {
    var queue = PriorityQueue<Int>()
    
    queue.enqueue(1)
    queue.enqueue(2)
    queue.enqueue(3)
    
    XCTAssertFalse(queue.isEmpty)
    XCTAssertEqual(3, queue.count)
    XCTAssertEqual(1, queue.front)
    
    for (i, element) in queue.enumerated() {
      XCTAssertEqual(i + 1, element)
    }
  }
  
  func testPushesElementsWithNonNaturalOrdering() {
    var queue = PriorityQueue<Int>(isOrdered: >)
    
    queue.enqueue(1)
    queue.enqueue(2)
    queue.enqueue(3)
    
    XCTAssertFalse(queue.isEmpty)
    XCTAssertEqual(3, queue.count)
    XCTAssertEqual(3, queue.front)
    
    for i in 0..<3 {
      XCTAssertEqual(3 - i, queue.dequeue())
    }
  }
  
  func testPopsElement() {
    var queue: PriorityQueue = [1]
    
    XCTAssertEqual(1, queue.dequeue())
    
    XCTAssertTrue(queue.isEmpty)
    XCTAssertEqual(0, queue.count)
    XCTAssertEqual(nil, queue.front)
  }
  
  func testPopsElements() {
    var queue: PriorityQueue = [1, 2, 3]
    
    XCTAssertEqual(1, queue.dequeue())
    XCTAssertEqual(2, queue.dequeue())
    XCTAssertEqual(3, queue.dequeue())
    
    XCTAssertTrue(queue.isEmpty)
    XCTAssertEqual(0, queue.count)
    XCTAssertEqual(nil, queue.front)
  }
  
  func testPopsElementsWithNonNaturalOrdering() {
    var queue = PriorityQueue([1, 2, 3], isOrdered: >)
    
    XCTAssertEqual(3, queue.dequeue())
    XCTAssertEqual(2, queue.dequeue())
    XCTAssertEqual(1, queue.dequeue())
    
    XCTAssertTrue(queue.isEmpty)
    XCTAssertEqual(0, queue.count)
    XCTAssertEqual(nil, queue.front)
  }
  
  func testEquals() {
    XCTAssertTrue(PriorityQueue<Int>() == [])
    XCTAssertTrue([] == PriorityQueue<Int>([]))
    XCTAssertTrue(PriorityQueue<Int>() == PriorityQueue<Int>([]))
    
    let queue: PriorityQueue = [1, 2, 3]
    var anotherQueue: PriorityQueue = [1, 2]
    XCTAssertTrue(queue != anotherQueue)
    
    anotherQueue.enqueue(3)
    XCTAssertTrue(queue == anotherQueue)
  }
  
  func testPushingPerformance() {
    measure {
      var queue = PriorityQueue<Int>()
      for i in 0..<100_000 {
        queue.enqueue(i)
      }
    }
  }
  
  func testPushingPoppingPerformance() {
    measure {
      var queue = PriorityQueue<Int>()
      for i in 0..<100_000 {
        queue.enqueue(i)
        XCTAssertEqual(i, queue.dequeue())
      }
    }
  }
  
  func testGetsDescriptions() {
    var queue: PriorityQueue<Int> = []
    XCTAssertEqual(queue.description, "[]")
    XCTAssertEqual(queue.debugDescription, "PriorityQueue([])")
    
    queue = [1, 2]
    XCTAssertEqual(queue.description, "[1, 2]")
    XCTAssertEqual(queue.debugDescription, "PriorityQueue([1, 2])")
  }
}
