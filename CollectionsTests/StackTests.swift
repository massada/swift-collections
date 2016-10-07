//
// StackTests.swift
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
    
    for (i, element) in stack.enumerated() {
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
    
    for (i, element) in stack.enumerated() {
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
    measure {
      var stack = Stack<Int>()
      for i in 0..<100_000 {
        stack.push(i)
      }
    }
  }
  
  func testPushingPoppingPerformance() {
    measure {
      var stack = Stack<Int>()
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
