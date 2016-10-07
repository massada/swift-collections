//
// LinkedListTests.swift
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

class LinkedListTests : XCTestCase {
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func testInitialises() {
    let list = LinkedList<Int>()
    
    XCTAssert(list.isEmpty)
    XCTAssertEqual(0, list.count)
    XCTAssertEqual(nil, list.first)
    XCTAssertEqual(nil, list.last)
    XCTAssertTrue(list.startIndex == list.endIndex)
  }
  
  func testInitialisesFromEmptyArrayLiteral() {
    let list: LinkedList<Int> = []
    
    XCTAssertEqual(0, list.count)
    XCTAssertTrue(list.isEmpty)
    XCTAssertEqual(nil, list.first)
    XCTAssertEqual(nil, list.last)
    XCTAssertTrue(list.startIndex == list.endIndex)
  }
  
  func testInitialisesFromArrayLiteral() {
    let list: LinkedList = [1, 2, 3]
    
    XCTAssertEqual(3, list.count)
    XCTAssertFalse(list.isEmpty)
    XCTAssertEqual(1, list.first)
    XCTAssertEqual(3, list.last)
    
    for (i, element) in list.enumerated() {
      XCTAssertEqual(i + 1, element)
    }
  }
  
  func testInitialisesFromEmptySequence() {
    let list = LinkedList<Int>([])
    
    XCTAssertEqual(0, list.count)
    XCTAssertTrue(list.isEmpty)
    XCTAssertEqual(nil, list.first)
    XCTAssertEqual(nil, list.last)
    XCTAssertTrue(list.startIndex == list.endIndex)
  }
  
  func testInitialisesFromSequence() {
    let list = LinkedList<Int>([1, 2, 3])
    
    XCTAssertEqual(3, list.count)
    XCTAssertFalse(list.isEmpty)
    XCTAssertEqual(1, list.first)
    XCTAssertEqual(3, list.last)
    
    for (i, element) in list.enumerated() {
      XCTAssertEqual(i + 1, element)
    }
  }
  
  func testReservesCapacity() {
    var list = LinkedList<Int>()
  
    // Does nothing, just here for code coverage
    list.reserveCapacity(0)
  }
  
  func testRemovesAll() {
    var list: LinkedList = [1, 2, 3]
    
    list.removeAll()
    XCTAssert(list.isEmpty)
    XCTAssertEqual(0, list.count)
    XCTAssertEqual(nil, list.first)
    XCTAssertEqual(nil, list.last)
  }
  
  func testAppending() {
    var list = LinkedList<Int>()
    
    list.append(1)
    XCTAssertEqual(1, list.count)
    XCTAssertFalse(list.isEmpty)
    XCTAssertEqual(1, list.first)
    XCTAssertEqual(1, list.last)
    
    for (i, element) in list.enumerated() {
      XCTAssertEqual(i + 1, element)
      XCTAssertEqual(i + 1, list[list.index(list.startIndex, offsetBy: i)])
    }
  }
  
  func testAppendingSequence() {
    var list = LinkedList<Int>()
    
    list.appendContentsOf(AnySequence([1, 2, 3]))
    XCTAssertEqual(3, list.count)
    XCTAssertFalse(list.isEmpty)
    XCTAssertEqual(1, list.first)
    XCTAssertEqual(3, list.last)
    
    for (i, element) in list.enumerated() {
      XCTAssertEqual(i + 1, element)
      XCTAssertEqual(i + 1, list[list.index(list.startIndex, offsetBy: i)])
    }
  }
  
  func testAppendingCollection() {
    var list = LinkedList<Int>()
    
    list.appendContentsOf([1, 2, 3])
    XCTAssertEqual(3, list.count)
    XCTAssertFalse(list.isEmpty)
    XCTAssertEqual(1, list.first)
    XCTAssertEqual(3, list.last)
    
    for (i, element) in list.enumerated() {
      XCTAssertEqual(i + 1, element)
      XCTAssertEqual(i + 1, list[list.index(list.startIndex, offsetBy: i)])
    }
  }
  
  func testAppendingAndRemovingFirst() {
    var list = LinkedList<Int>()
    
    for i in 0..<16 {
      list.append(i)
      XCTAssertEqual(i, list.removeFirst())
      XCTAssert(list.isEmpty)
    }
    
    for i in 0..<16 {
      list.append(i)
      if i % 2 == 0 {
        XCTAssertEqual(i / 2, list.removeFirst())
      }
    }
    
    XCTAssertEqual(8, list.count)
    
    list.removeFirst(0)
    XCTAssertEqual(8, list.count)
    
    list.removeFirst(8)
    XCTAssert(list.isEmpty)
  }
  
  func testAppendingAndRemovingLast() {
    var list = LinkedList<Int>()
    
    for i in 0..<16 {
      list.append(i)
      XCTAssertEqual(i, list.removeLast())
      XCTAssert(list.isEmpty)
    }
    
    for i in 0..<16 {
      list.append(i)
      if i % 2 == 0 {
        XCTAssertEqual(i, list.removeLast())
      }
    }
    
    XCTAssertEqual(8, list.count)
    
    list.removeLast(0)
    XCTAssertEqual(8, list.count)
    
    list.removeLast(8)
    XCTAssert(list.isEmpty)
  }
  
  func testPrepending() {
    var list = LinkedList<Int>()
    
    list.prepend(1)
    XCTAssertEqual(1, list.count)
    XCTAssertFalse(list.isEmpty)
    XCTAssertEqual(1, list.first)
    XCTAssertEqual(1, list.last)
    
    for (i, element) in list.enumerated() {
      XCTAssertEqual(i + 1, element)
      XCTAssertEqual(i + 1, list[list.index(list.startIndex, offsetBy: i)])
    }
  }
  
  func testPrependingSequence() {
    var list = LinkedList<Int>()
    
    list.prependContentsOf(AnySequence([1, 2, 3]))
    XCTAssertEqual(3, list.count)
    XCTAssertFalse(list.isEmpty)
    XCTAssertEqual(1, list.first)
    XCTAssertEqual(3, list.last)
    
    for (i, element) in list.enumerated() {
      XCTAssertEqual(i + 1, element)
      XCTAssertEqual(i + 1, list[list.index(list.startIndex, offsetBy: i)])
    }
  }
  
  func testPrependingCollection() {
    var list = LinkedList<Int>()
    
    list.prependContentsOf([1, 2, 3])
    XCTAssertEqual(3, list.count)
    XCTAssertFalse(list.isEmpty)
    XCTAssertEqual(1, list.first)
    XCTAssertEqual(3, list.last)
    
    for (i, element) in list.enumerated() {
      XCTAssertEqual(i + 1, element)
      XCTAssertEqual(i + 1, list[list.index(list.startIndex, offsetBy: i)])
    }
  }
  
  func testPrependingAndRemovingFirst() {
    var list = LinkedList<Int>()
    
    for i in 0..<16 {
      list.prepend(i)
      XCTAssertEqual(i, list.removeFirst())
      XCTAssert(list.isEmpty)
    }
    
    for i in 0..<16 {
      list.prepend(i)
      if i % 2 == 0 {
        XCTAssertEqual(i, list.removeFirst())
      }
    }
    
    XCTAssertEqual(8, list.count)
    
    list.removeFirst(8)
    XCTAssert(list.isEmpty)
  }
  
  func testPrependingAndRemovingLast() {
    var list = LinkedList<Int>()
    
    for i in 0..<16 {
      list.prepend(i)
      XCTAssertEqual(i, list.removeLast())
      XCTAssert(list.isEmpty)
    }
    
    for i in 0..<16 {
      list.prepend(i)
      if i % 2 == 0 {
        XCTAssertEqual(i / 2, list.removeLast())
      }
    }
    
    XCTAssertEqual(8, list.count)
    
    while list.last != nil {
      _ = list.removeLast()
    }
    XCTAssert(list.isEmpty)
  }
  
  func testAppendingPrependingAndRemovingLast() {
    var list = LinkedList<Int>()
    
    // 0, 1, 2, 3, 4, 5
    list.append(3)
    list.prepend(2)
    list.append(4)
    list.prepend(1)
    list.append(5)
    list.prepend(0)
    XCTAssertEqual(6, list.count)
    
    for i in (0..<6).reversed() {
      XCTAssertEqual(i, list.removeLast())
    }
  }
  
  func testAppendingPrependingAndRemovingFirst() {
    var list = LinkedList<Int>()
    
    // 0, 1, 2, 3, 4, 5
    list.append(3)
    list.prepend(2)
    list.append(4)
    list.prepend(1)
    list.append(5)
    list.prepend(0)
    XCTAssertEqual(6, list.count)
    
    for i in 0..<6 {
      XCTAssertEqual(i, list.removeFirst())
    }
  }
  
  func testSubscripting() {
    var list: LinkedList = [0, 0, 0]
    
    list[list.startIndex] = 1
    
    var i = list.startIndex
    while i != list.endIndex {
      list[i] = 1
      i = list.index(after: i)
    }
    
    for i in list.indices {
      XCTAssertEqual(1, list[i])
    }
    
    i = list.startIndex
    while i != list.endIndex {
      list[i] = 0
      i = list.index(after: i)
    }
    
    for i in list.indices {
      XCTAssertEqual(0, list[i])
    }
  }
  
  func testCopyOnWrite() {
    let list: LinkedList = [1, 2, 3]
    
    // prepend(_:)
    var copy = list
    copy.prepend(0)
    XCTAssertTrue(copy != list)
    
    // append(_:)
    copy = list
    copy.append(0)
    XCTAssertTrue(copy != list)
    
    // removeFirst()
    copy = list
    _ = copy.removeFirst()
    XCTAssertTrue(copy != list)
    
    // removeFirst(_:)
    copy = list
    _ = copy.removeFirst(2)
    XCTAssertTrue(copy != list)
    
    // removeLast()
    copy = list
    _ = copy.removeLast()
    XCTAssertTrue(copy != list)
    
    // removeLast(_:)
    copy = list
    _ = copy.removeLast(2)
    XCTAssertTrue(copy != list)
    
    // removeAll()
    copy = list
    copy.removeAll()
    XCTAssertTrue(copy != list)
    
    // insert(_:atIndex:)
    copy = list
    copy.insert(0, atIndex: copy.index(after: copy.startIndex))
    XCTAssertTrue(copy != list)
    
    // removeAtIndex(_:)
    copy = list
    _ = copy.removeAtIndex(copy.index(after: copy.startIndex))
    XCTAssertTrue(copy != list)
    
    // subscript setter
    copy = list
    copy[copy.index(after: copy.startIndex)] = 0
    XCTAssertTrue(copy != list)
  }
  
  func testEquals() {
    XCTAssertTrue(LinkedList<Int>() == [])
    XCTAssertTrue([] == LinkedList<Int>([]))
    XCTAssertTrue(LinkedList<Int>() == LinkedList<Int>([]))
    
    let list: LinkedList = [1, 2, 3]
    var anotherList: LinkedList = [1, 2]
    XCTAssertTrue(list != anotherList)
    
    anotherList.append(3)
    XCTAssertTrue(list == anotherList)
  }
  
  func testGetsDescriptions() {
    var list: LinkedList<Int> = []
    XCTAssertEqual(list.description, "[]")
    XCTAssertEqual(list.debugDescription, "LinkedList([])")
    
    list = [1, 2]
    XCTAssertEqual(list.description, "[1, 2]")
    XCTAssertEqual(list.debugDescription, "LinkedList([1, 2])")
  }
}
