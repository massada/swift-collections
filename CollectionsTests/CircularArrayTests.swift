//
//  CircularArrayTests.swift
//  Collections
//
//  Created by José Massada on 24/01/2016.
//  Copyright © 2016 José Massada. All rights reserved.
//

import XCTest
@testable import Collections

class CircularArrayTests : XCTestCase {
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func testInitialises() {
    let array = CircularArray<Int>()
    
    XCTAssertEqual(0, array.capacity)
    XCTAssertEqual(0, array.count)
    XCTAssertTrue(array.isEmpty)
    XCTAssertEqual(nil, array.first)
    XCTAssertEqual(nil, array.last)
    XCTAssertTrue(array.startIndex == array.endIndex)
  }
  
  func testInitialisesWithMinimumCapacity() {
    for i in 0..<6 {
      let array = CircularArray<Int>(minimumCapacity: i)
      
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
    let array: CircularArray<Int> = []
    
    XCTAssertEqual(0, array.capacity)
    XCTAssertEqual(0, array.count)
    XCTAssertTrue(array.isEmpty)
    XCTAssertEqual(nil, array.first)
    XCTAssertEqual(nil, array.last)
    XCTAssertTrue(array.startIndex == array.endIndex)
  }
  
  func testInitialisesFromArrayLiteral() {
    let array: CircularArray = [1, 2, 3]
    
    XCTAssertEqual(4, array.capacity)
    XCTAssertEqual(3, array.count)
    XCTAssertFalse(array.isEmpty)
    XCTAssertEqual(1, array.first)
    XCTAssertEqual(3, array.last)
    XCTAssertEqual(0, array.startIndex)
    XCTAssertEqual(3, array.endIndex)
    
    for (i, element) in array.enumerate() {
      XCTAssertEqual(i + 1, element)
    }
  }
  
  func testInitialisesFromEmptySequence() {
    let array = CircularArray<Int>([])
    
    XCTAssertEqual(0, array.capacity)
    XCTAssertEqual(0, array.count)
    XCTAssertTrue(array.isEmpty)
    XCTAssertEqual(nil, array.first)
    XCTAssertEqual(nil, array.last)
    XCTAssertTrue(array.startIndex == array.endIndex)
  }
  
  func testInitialisesFromSequence() {
    let array = CircularArray<Int>([1, 2, 3])
    
    XCTAssertEqual(4, array.capacity)
    XCTAssertEqual(3, array.count)
    XCTAssertFalse(array.isEmpty)
    XCTAssertEqual(1, array.first)
    XCTAssertEqual(3, array.last)
    XCTAssertEqual(0, array.startIndex)
    XCTAssertEqual(3, array.endIndex)
    
    for (i, element) in array.enumerate() {
      XCTAssertEqual(i + 1, element)
    }
  }
  
  func testReservesCapacity() {
    var array: CircularArray<Int> = []
    
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
    var array: CircularArray = [1, 2, 3]
    
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
    var array = CircularArray<Int>()
    
    array.append(1)
    XCTAssertEqual(2, array.capacity)
    XCTAssertEqual(1, array.count)
    XCTAssertFalse(array.isEmpty)
    XCTAssertEqual(1, array.first)
    XCTAssertEqual(1, array.last)
    XCTAssertEqual(0, array.startIndex)
    XCTAssertEqual(1, array.endIndex)
    
    for (i, element) in array.enumerate() {
      XCTAssertEqual(i + 1, element)
    }
  }
  
  func testAppendingSequence() {
    var array = CircularArray<Int>()
    
    array.appendContentsOf(AnySequence([1, 2, 3]))
    XCTAssertEqual(4, array.capacity)
    XCTAssertEqual(3, array.count)
    XCTAssertFalse(array.isEmpty)
    XCTAssertEqual(1, array.first)
    XCTAssertEqual(3, array.last)
    XCTAssertEqual(0, array.startIndex)
    XCTAssertEqual(3, array.endIndex)
    
    for (i, element) in array.enumerate() {
      XCTAssertEqual(i + 1, element)
    }
  }
  
  func testAppendingCollection() {
    var array = CircularArray<Int>()
    
    array.appendContentsOf([1, 2, 3])
    XCTAssertEqual(4, array.capacity)
    XCTAssertEqual(3, array.count)
    XCTAssertFalse(array.isEmpty)
    XCTAssertEqual(1, array.first)
    XCTAssertEqual(3, array.last)
    XCTAssertEqual(0, array.startIndex)
    XCTAssertEqual(3, array.endIndex)
    
    for (i, element) in array.enumerate() {
      XCTAssertEqual(i + 1, element)
    }
  }
  
  func testAppendingAndRemovingFirst() {
    var array = CircularArray<Int>()
    
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
    var array = CircularArray<Int>()
    
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
    var array = CircularArray<Int>()
    
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
    var array = CircularArray<Int>()
    
    array.prependContentsOf(AnySequence([1, 2, 3]))
    XCTAssertEqual(4, array.capacity)
    XCTAssertEqual(3, array.count)
    XCTAssertFalse(array.isEmpty)
    XCTAssertEqual(1, array.first)
    XCTAssertEqual(3, array.last)
    XCTAssertEqual(0, array.startIndex)
    XCTAssertEqual(3, array.endIndex)
    
    for (i, element) in array.enumerate() {
      XCTAssertEqual(i + 1, element)
    }
  }
  
  func testPrependingCollection() {
    var array = CircularArray<Int>()
    
    array.prependContentsOf([1, 2, 3])
    XCTAssertEqual(4, array.capacity)
    XCTAssertEqual(3, array.count)
    XCTAssertFalse(array.isEmpty)
    XCTAssertEqual(1, array.first)
    XCTAssertEqual(3, array.last)
    XCTAssertEqual(0, array.startIndex)
    XCTAssertEqual(3, array.endIndex)
    
    for (i, element) in array.enumerate() {
      XCTAssertEqual(i + 1, element)
    }
  }
  
  func testPrependingAndRemovingFirst() {
    var array = CircularArray<Int>()
    
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
    var array = CircularArray<Int>()
    
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
    var array = CircularArray<Int>()
    
    // 0, 1, 2, 3, 4, 5
    array.append(3)
    array.prepend(2)
    array.append(4)
    array.prepend(1)
    array.append(5)
    array.prepend(0)
    XCTAssertEqual(6, array.count)
    
    for i in (0..<6).reverse() {
      XCTAssertEqual(i, array.removeLast())
    }
  }
  
  func testAppendingPrependingAndRemovingFirst() {
    var array = CircularArray<Int>()
    
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
    var array: CircularArray = [0, 0, 0]
    
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
    let array: CircularArray = [1, 2, 3]
    assertCopiesOnWrite(array)
  }
  
  func testWrappedCopyOnWrite()
  {
    var array = CircularArray<Int>()
    array.prepend(3)
    array.prepend(2)
    array.prepend(1)
    
    assertCopiesOnWrite(array)
  }
  
  func testUnsafeAdressing() {
    var array: CircularArray = [1, 2, 3]
    
    // test unwrapped buffer
    
    // 1, 2, 3
    array.withUnsafeBufferPointer {
      for i in 0..<3 {
        XCTAssertEqual(i + 1, ($0.baseAddress + i).memory)
      }
    }
    array.withUnsafeMutableBufferPointer {
      for i in 0..<3 {
        XCTAssertEqual(i + 1, ($0.baseAddress + i).memory)
        ($0.baseAddress + i).memory = 3 - i
      }
    }
    
    // 3, 2, 1
    array.withUnsafeBufferPointer {
      for i in 0..<3 {
        XCTAssertEqual(3 - i, ($0.baseAddress + i).memory)
      }
    }
    
    // test wrapped buffer
    array.prepend(4)
    
    // 4, 3, 2, 1
    array.withUnsafeBufferPointer {
      for i in 0..<4 {
        XCTAssertEqual(4 - i, ($0.baseAddress + i).memory)
      }
    }
    array.withUnsafeMutableBufferPointer {
      for i in 0..<4 {
        XCTAssertEqual(4 - i, ($0.baseAddress + i).memory)
        ($0.baseAddress + i).memory = i + 1
      }
    }
    
    // 1, 2, 3, 4
    array.withUnsafeBufferPointer {
      for i in 0..<4 {
        XCTAssertEqual(i + 1, ($0.baseAddress + i).memory)
      }
    }
  }
  
  func testEquals() {
    XCTAssertTrue(CircularArray<Int>() == [])
    XCTAssertTrue([] == CircularArray<Int>([]))
    XCTAssertTrue(CircularArray<Int>() == CircularArray<Int>([]))
    
    let array: CircularArray = [1, 2, 3]
    var anotherArray: CircularArray = [1, 2]
    XCTAssertTrue(array != anotherArray)
    
    anotherArray.append(3)
    XCTAssertTrue(array == anotherArray)
  }
  
  func testGetsDescriptions() {
    var array: CircularArray<Int> = []
    XCTAssertEqual(array.description, "[]")
    XCTAssertEqual(array.debugDescription, "CircularArray([])")
    
    array = [1, 2]
    XCTAssertEqual(array.description, "[1, 2]")
    XCTAssertEqual(array.debugDescription, "CircularArray([1, 2])")
  }
  
  func assertCopiesOnWrite(array: CircularArray<Int>) {
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
