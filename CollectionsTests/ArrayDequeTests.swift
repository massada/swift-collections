//
// ArrayDequeTests.swift
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

class ArrayDequeTests : XCTestCase {
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func testInitialises() {
    let array = ArrayDeque<Int>()
    
    XCTAssertEqual(0, array.capacity)
    XCTAssertEqual(0, array.count)
    XCTAssertTrue(array.isEmpty)
    XCTAssertEqual(nil, array.first)
    XCTAssertEqual(nil, array.last)
    XCTAssertTrue(array.startIndex == array.endIndex)
  }
  
  func testInitialisesWithMinimumCapacity() {
    for i in 0..<6 {
      let array = ArrayDeque<Int>(minimumCapacity: i)
      
      if i == 0 {
        XCTAssertEqual(0, array.capacity)
      } else {
        var capacity = 2
        while capacity < i {
          capacity <<= 1
        }
        XCTAssertEqual(capacity, array.capacity)
      }
      
      XCTAssertEqual(0, array.count)
      XCTAssertTrue(array.isEmpty)
      XCTAssertEqual(nil, array.first)
      XCTAssertEqual(nil, array.last)
      XCTAssertTrue(array.startIndex == array.endIndex)
    }
  }
  
  func testInitialisesFromEmptyArrayLiteral() {
    let array: ArrayDeque<Int> = []
    
    XCTAssertEqual(0, array.capacity)
    XCTAssertEqual(0, array.count)
    XCTAssertTrue(array.isEmpty)
    XCTAssertEqual(nil, array.first)
    XCTAssertEqual(nil, array.last)
    XCTAssertTrue(array.startIndex == array.endIndex)
  }
  
  func testInitialisesFromArrayLiteral() {
    let array: ArrayDeque = [1, 2, 3]
    
    XCTAssertEqual(4, array.capacity)
    XCTAssertEqual(3, array.count)
    XCTAssertFalse(array.isEmpty)
    XCTAssertEqual(1, array.first)
    XCTAssertEqual(3, array.last)
    XCTAssertEqual(0, array.startIndex)
    XCTAssertEqual(3, array.endIndex)
    
    for (i, element) in array.enumerated() {
      XCTAssertEqual(i + 1, element)
    }
  }
  
  func testInitialisesFromEmptySequence() {
    let array = ArrayDeque<Int>([])
    
    XCTAssertEqual(0, array.capacity)
    XCTAssertEqual(0, array.count)
    XCTAssertTrue(array.isEmpty)
    XCTAssertEqual(nil, array.first)
    XCTAssertEqual(nil, array.last)
    XCTAssertTrue(array.startIndex == array.endIndex)
  }
  
  func testInitialisesFromSequence() {
    let array = ArrayDeque<Int>([1, 2, 3])
    
    XCTAssertEqual(4, array.capacity)
    XCTAssertEqual(3, array.count)
    XCTAssertFalse(array.isEmpty)
    XCTAssertEqual(1, array.first)
    XCTAssertEqual(3, array.last)
    XCTAssertEqual(0, array.startIndex)
    XCTAssertEqual(3, array.endIndex)
    
    for (i, element) in array.enumerated() {
      XCTAssertEqual(i + 1, element)
    }
  }
  
  func testReservesCapacity() {
    var array: ArrayDeque<Int> = []
    
    var capacity = 0
    for i in 0..<32 {
      array.reserveCapacity(i)
      XCTAssertEqual(capacity, array.capacity)
      
      if i % max(2, capacity) == 0 {
        capacity = max(2, capacity << 1)
      }
    }
  }
  
  func testRemovesAll() {
    var array: ArrayDeque = [1, 2, 3]
    
    array.removeAll()
    XCTAssertEqual(0, array.capacity)
    XCTAssertEqual(0, array.count)
    XCTAssertTrue(array.isEmpty)
    XCTAssertEqual(nil, array.first)
    XCTAssertEqual(nil, array.last)
    XCTAssertTrue(array.startIndex == array.endIndex)
    
    array = [1, 2, 3]
    
    array.removeAll(keepCapacity: true)
    XCTAssertEqual(4, array.capacity)
    XCTAssertEqual(0, array.count)
    XCTAssertTrue(array.isEmpty)
    XCTAssertEqual(nil, array.first)
    XCTAssertEqual(nil, array.last)
    XCTAssertTrue(array.startIndex == array.endIndex)
  }
  
  func testAppending() {
    var array = ArrayDeque<Int>()
    
    array.append(1)
    XCTAssertEqual(2, array.capacity)
    XCTAssertEqual(1, array.count)
    XCTAssertFalse(array.isEmpty)
    XCTAssertEqual(1, array.first)
    XCTAssertEqual(1, array.last)
    XCTAssertEqual(0, array.startIndex)
    XCTAssertEqual(1, array.endIndex)
    
    for (i, element) in array.enumerated() {
      XCTAssertEqual(i + 1, element)
    }
  }
  
  func testAppendingSequence() {
    var array = ArrayDeque<Int>()
    
    array.appendContentsOf(AnySequence([1, 2, 3]))
    XCTAssertEqual(4, array.capacity)
    XCTAssertEqual(3, array.count)
    XCTAssertFalse(array.isEmpty)
    XCTAssertEqual(1, array.first)
    XCTAssertEqual(3, array.last)
    XCTAssertEqual(0, array.startIndex)
    XCTAssertEqual(3, array.endIndex)
    
    for (i, element) in array.enumerated() {
      XCTAssertEqual(i + 1, element)
    }
  }
  
  func testAppendingCollection() {
    var array = ArrayDeque<Int>()
    
    array.appendContentsOf([1, 2, 3])
    XCTAssertEqual(4, array.capacity)
    XCTAssertEqual(3, array.count)
    XCTAssertFalse(array.isEmpty)
    XCTAssertEqual(1, array.first)
    XCTAssertEqual(3, array.last)
    XCTAssertEqual(0, array.startIndex)
    XCTAssertEqual(3, array.endIndex)
    
    for (i, element) in array.enumerated() {
      XCTAssertEqual(i + 1, element)
    }
  }
  
  func testAppendingAndRemovingFirst() {
    var array = ArrayDeque<Int>()
    
    for i in 0..<16 {
      array.append(i)
      XCTAssertEqual(i, array.removeFirst())
      XCTAssert(array.isEmpty)
    }
    
    for i in 0..<16 {
      array.append(i)
      if i % 2 == 0 {
        XCTAssertEqual(i / 2, array.removeFirst())
      }
    }
    
    XCTAssertEqual(8, array.count)
    
    array.removeFirst(8)
    XCTAssert(array.isEmpty)
  }
  
  func testAppendingAndRemovingLast() {
    var array = ArrayDeque<Int>()
    
    for i in 0..<16 {
      array.append(i)
      XCTAssertEqual(i, array.removeLast())
      XCTAssert(array.isEmpty)
    }
    
    for i in 0..<16 {
      array.append(i)
      if i % 2 == 0 {
        XCTAssertEqual(i, array.removeLast())
      }
    }
    
    XCTAssertEqual(8, array.count)
    
    array.removeLast(8)
    XCTAssert(array.isEmpty)
  }
  
  func testPrepending() {
    var array = ArrayDeque<Int>()
    
    array.prepend(1)
    XCTAssertEqual(2, array.capacity)
    XCTAssertEqual(1, array.count)
    XCTAssertFalse(array.isEmpty)
    XCTAssertEqual(1, array.first)
    XCTAssertEqual(1, array.last)
    XCTAssertEqual(0, array.startIndex)
    XCTAssertEqual(1, array.endIndex)
    
    for element in array {
      XCTAssertEqual(1, element)
    }
  }
  
  func testPrependingSequence() {
    var array = ArrayDeque<Int>()
    
    array.prependContentsOf(AnySequence([1, 2, 3]))
    XCTAssertEqual(4, array.capacity)
    XCTAssertEqual(3, array.count)
    XCTAssertFalse(array.isEmpty)
    XCTAssertEqual(1, array.first)
    XCTAssertEqual(3, array.last)
    XCTAssertEqual(0, array.startIndex)
    XCTAssertEqual(3, array.endIndex)
    
    for (i, element) in array.enumerated() {
      XCTAssertEqual(i + 1, element)
    }
  }
  
  func testPrependingCollection() {
    var array = ArrayDeque<Int>()
    
    array.prependContentsOf([1, 2, 3])
    XCTAssertEqual(4, array.capacity)
    XCTAssertEqual(3, array.count)
    XCTAssertFalse(array.isEmpty)
    XCTAssertEqual(1, array.first)
    XCTAssertEqual(3, array.last)
    XCTAssertEqual(0, array.startIndex)
    XCTAssertEqual(3, array.endIndex)
    
    for (i, element) in array.enumerated() {
      XCTAssertEqual(i + 1, element)
    }
  }
  
  func testPrependingAndRemovingFirst() {
    var array = ArrayDeque<Int>()
    
    for i in 0..<16 {
      array.prepend(i)
      XCTAssertEqual(i, array.removeFirst())
      XCTAssert(array.isEmpty)
    }
    
    for i in 0..<16 {
      array.prepend(i)
      if i % 2 == 0 {
        XCTAssertEqual(i, array.removeFirst())
      }
    }
    
    XCTAssertEqual(8, array.count)
    
    array.removeFirst(8)
    XCTAssert(array.isEmpty)
  }
  
  func testPrependingAndRemovingLast() {
    var array = ArrayDeque<Int>()
    
    for i in 0..<16 {
      array.prepend(i)
      XCTAssertEqual(i, array.removeLast())
      XCTAssert(array.isEmpty)
    }
    
    for i in 0..<16 {
      array.prepend(i)
      if i % 2 == 0 {
        XCTAssertEqual(i / 2, array.removeLast())
      }
    }
    
    XCTAssertEqual(8, array.count)
    
    array.removeLast(8)
    XCTAssert(array.isEmpty)
  }
  
  func testAppendingPrependingAndRemovingLast() {
    var array = ArrayDeque<Int>()
    
    // 0, 1, 2, 3, 4, 5
    array.append(3)
    array.prepend(2)
    array.append(4)
    array.prepend(1)
    array.append(5)
    array.prepend(0)
    XCTAssertEqual(6, array.count)
    
    for i in (0..<6).reversed() {
      XCTAssertEqual(i, array.removeLast())
    }
  }
  
  func testAppendingPrependingAndRemovingFirst() {
    var array = ArrayDeque<Int>()
    
    // 0, 1, 2, 3, 4, 5
    array.append(3)
    array.prepend(2)
    array.append(4)
    array.prepend(1)
    array.append(5)
    array.prepend(0)
    XCTAssertEqual(6, array.count)
    
    for i in 0..<6 {
      XCTAssertEqual(i, array.removeFirst())
    }
  }
  
  func testSubscripting() {
    var array: ArrayDeque = [0, 0, 0]
    
    for i in 0..<3 {
      array[i] = 1
    }
    
    for i in 0..<3 {
      XCTAssertEqual(1, array[i])
    }
    
    for i in 0..<3 {
      array[i] = 0
    }

    for i in 0..<3 {
      XCTAssertEqual(0, array[i])
    }
  }
  
  func testUnwrappedCopyOnWrite()
  {
    let array: ArrayDeque = [1, 2, 3]
    assertCopiesOnWrite(array)
  }
  
  func testWrappedCopyOnWrite()
  {
    var array = ArrayDeque<Int>()
    array.prepend(3)
    array.prepend(2)
    array.prepend(1)
    
    assertCopiesOnWrite(array)
  }
  
  func testEquals() {
    XCTAssertTrue(ArrayDeque<Int>() == [])
    XCTAssertTrue([] == ArrayDeque<Int>([]))
    XCTAssertTrue(ArrayDeque<Int>() == ArrayDeque<Int>([]))
    
    let array: ArrayDeque = [1, 2, 3]
    var anotherArray: ArrayDeque = [1, 2]
    XCTAssertTrue(array != anotherArray)
    
    anotherArray.append(3)
    XCTAssertTrue(array == anotherArray)
  }
  
  func testGetsDescriptions() {
    var array: ArrayDeque<Int> = []
    XCTAssertEqual(array.description, "[]")
    XCTAssertEqual(array.debugDescription, "ArrayDeque([])")
    
    array = [1, 2]
    XCTAssertEqual(array.description, "[1, 2]")
    XCTAssertEqual(array.debugDescription, "ArrayDeque([1, 2])")
  }
  
  func assertCopiesOnWrite(_ array: ArrayDeque<Int>) {
    // reserveCapacity(_:)
    var copy = array
    copy.reserveCapacity(array.capacity << 1)
    XCTAssertNotEqual(array.capacity, copy.capacity)
    
    // prepend(_:)
    copy = array
    copy.prepend(4)
    XCTAssertTrue(array != copy)
    
    // prependContentsOf(_:)
    copy = array
    copy.prependContentsOf([1, 2, 3])
    XCTAssertTrue(array != copy)
    
    // prependContentsOf(_:)
    copy = array
    copy.prependContentsOf(AnySequence([1, 2, 3]))
    XCTAssertTrue(array != copy)
    
    // append(_:)
    copy = array
    copy.append(4)
    XCTAssertTrue(array != copy)
    
    // appendContentsOf(_:)
    copy = array
    copy.appendContentsOf([1, 2, 3])
    XCTAssertTrue(array != copy)
    
    // appendContentsOf(_:)
    copy = array
    copy.appendContentsOf(AnySequence([1, 2, 3]))
    XCTAssertTrue(array != copy)
    
    // removeAll()
    copy = array
    copy.removeAll()
    XCTAssertTrue(array != copy)
    copy = array
    copy.removeAll(keepCapacity: true)
    XCTAssertTrue(array != copy)
    
    // removeFirst()
    copy = array
    _ = copy.removeFirst()
    XCTAssertTrue(array != copy)
    
    // removeFirst(_:)
    copy = array
    copy.removeFirst(0)
    XCTAssertTrue(array == copy)
    copy.removeFirst(2)
    XCTAssertTrue(array != copy)
    
    // removeLast()
    copy = array
    _ = copy.removeLast()
    XCTAssertTrue(array != copy)
    
    // removeLast(_:)
    copy = array
    copy.removeLast(0)
    XCTAssertTrue(array == copy)
    copy.removeLast(2)
    XCTAssertTrue(array != copy)
    
    // subscript setter
    copy = array
    copy[0] = 0
    XCTAssertTrue(array != copy)
  }
}
