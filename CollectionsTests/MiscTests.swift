//
//  MiscTests.swift
//  Collections
//
//  Created by José Massada on 20/02/2016.
//  Copyright © 2016 José Massada. All rights reserved.
//

import XCTest
@testable import Collections

class MiscTests: XCTestCase {
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func testIsPowerOfTwo() {
    XCTAssertFalse(isPowerOfTwo(-1))
    XCTAssertFalse(isPowerOfTwo(0))
    
    // test all power of two values
    var i = 1
    while i != (Int.max >> 1) + 1 {
      XCTAssertTrue(isPowerOfTwo(i))
      i <<= 1
    }
    
    // test multiples of 3 since we can't possibly test for all values
    i = 3
    while i < (Int.max >> 1) + 1 {
      XCTAssertFalse(isPowerOfTwo(i))
      i <<= 1
    }
  }
  
  func testNearestPowerOfTwo() {
    XCTAssertTrue(nearestPowerOfTwo(-1) == 1)
    XCTAssertTrue(nearestPowerOfTwo(0) == 1)
    XCTAssertTrue(nearestPowerOfTwo(1) == 1)
    XCTAssertTrue(nearestPowerOfTwo(2) == 2)
    
    var i = 4
    while i != (Int.max >> 1) + 1 {
      XCTAssertTrue(nearestPowerOfTwo(i) == i)
      XCTAssertTrue(nearestPowerOfTwo(i - 1) == i)
      i <<= 1
    }
  }
}
