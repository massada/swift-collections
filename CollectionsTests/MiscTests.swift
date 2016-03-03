//
// MiscTests.swift
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
