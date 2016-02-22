//
//  StackTests.swift
//  Collections
//
//  Created by José Massada on 26/01/2016.
//  Copyright © 2016 José Massada. All rights reserved.
//

import XCTest
@testable import Collections

class StackTests : XCTestCase {
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func testInitialises() {
    let stack = Stack<Int>()
    
    XCTAssertTrue(stack.isEmpty)
    XCTAssertEqual(0, stack.count)
    XCTAssertEqual(nil, stack.top)
  }
  
  func testInitialisesFromEmptyArrayLiteral() {
    let stack: Stack<Int> = []
    
    XCTAssertTrue(stack.isEmpty)
    XCTAssertEqual(0, stack.count)
    XCTAssertEqual(nil, stack.top)
  }
  
  func testInitialisesFromArrayLiteral() {
    let stack: Stack = [1, 2, 3]
    
    XCTAssertFalse(stack.isEmpty)
    XCTAssertEqual(3, stack.count)
    XCTAssertEqual(3, stack.top)
    
    for (i, element) in stack.enumerate() {
      XCTAssertEqual(3 - i, element)
    }
  }
  
  func testInitialisesFromEmptySequence() {
    let stack = Stack<Int>([])
    
    XCTAssertTrue(stack.isEmpty)
    XCTAssertEqual(0, stack.count)
    XCTAssertEqual(nil, stack.top)
  }
  
  func testInitialisesFromSequence() {
    let stack = Stack<Int>([1, 2, 3])
    
    XCTAssertFalse(stack.isEmpty)
    XCTAssertEqual(3, stack.count)
    XCTAssertEqual(3, stack.top)
    
    for (i, element) in stack.enumerate() {
      XCTAssertEqual(3 - i, element)
    }
  }
  
  func testClears() {
    var stack: Stack = [1, 2, 3]
    
    stack.clear()
    XCTAssertTrue(stack.isEmpty)
    XCTAssertEqual(0, stack.count)
    XCTAssertEqual(nil, stack.top)
  }
  
  func testPushesElement() {
    var stack = Stack<Int>()
    
    stack.push(1)
    XCTAssertFalse(stack.isEmpty)
    XCTAssertEqual(1, stack.count)
    XCTAssertEqual(1, stack.top)
  }
  
  func testPushesElements() {
    var stack = Stack<Int>()
    
    stack.push(1)
    stack.push(2)
    stack.push(3)
    
    XCTAssertFalse(stack.isEmpty)
    XCTAssertEqual(3, stack.count)
    XCTAssertEqual(3, stack.top)
  }
  
  func testPopsElement() {
    var stack: Stack = [1]
    
    XCTAssertEqual(1, stack.pop())
    
    XCTAssertTrue(stack.isEmpty)
    XCTAssertEqual(0, stack.count)
    XCTAssertEqual(nil, stack.top)
  }
  
  func testPopsElements() {
    var stack: Stack = [1, 2, 3]
    
    XCTAssertEqual(3, stack.pop())
    XCTAssertEqual(2, stack.pop())
    XCTAssertEqual(1, stack.pop())
    
    XCTAssertTrue(stack.isEmpty)
    XCTAssertEqual(0, stack.count)
    XCTAssertEqual(nil, stack.top)
  }
  
  func testEquals() {
    XCTAssertTrue(Stack<Int>() == [])
    XCTAssertTrue([] == Stack<Int>([]))
    XCTAssertTrue(Stack<Int>() == Stack<Int>([]))
    
    let stack: Stack = [1, 2, 3]
    var anotherStack: Stack = [1, 2]
    XCTAssertTrue(stack != anotherStack)
    
    anotherStack.push(3)
    XCTAssertTrue(stack == anotherStack)
  }
  
  func testPushingPerformance() {
    var stack = Stack<Int>()
    
    measureBlock {
      for i in 0..<100_000 {
        stack.push(i)
      }
    }
  }
  
  func testPushingPoppingPerformance() {
    var stack = Stack<Int>()
    
    measureBlock {
      for i in 0..<100_000 {
        stack.push(i)
        XCTAssertEqual(i, stack.pop())
      }
    }
  }
  
  func testGetsDescriptions() {
    var stack: Stack<Int> = []
    XCTAssertEqual(stack.description, "[]")
    XCTAssertEqual(stack.debugDescription, "Stack([])")
    
    stack = [1, 2]
    XCTAssertEqual(stack.description, "[2, 1]")
    XCTAssertEqual(stack.debugDescription, "Stack([2, 1])")
  }
}
