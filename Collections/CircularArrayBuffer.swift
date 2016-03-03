//
// CircularArrayBuffer.swift
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

class CircularArrayBuffer<Element> {
  typealias Storage = UnsafeMutablePointer<Element>
  
  init() {
    storage_ = Storage()
  }
  
  init(minimumCapacity: Int) {
    var capacity = minimumCapacity
    if capacity > 0 {
      capacity = max(2, capacity)
      if !isPowerOfTwo(capacity) {
        capacity = nearestPowerOfTwo(capacity)
      }
    }
    
    capacity_ = capacity
    storage_ = Storage.alloc(capacity_)
  }
  
  init(buffer: CircularArrayBuffer) {
    capacity_ = buffer.capacity
    storage_ = Storage.alloc(capacity_)
    
    if buffer.frontIndex_ <= buffer.backIndex_ {
      storage_.initializeFrom(buffer.storage_ + buffer.frontIndex_,
        count: buffer.count)
    } else {
      // initialise head elements
      let frontCount = buffer.capacity_ &- buffer.frontIndex_
      storage_.initializeFrom(buffer.storage_ + buffer.frontIndex_,
        count: frontCount)
      
      // initialise tail elements
      (storage_ + frontCount).initializeFrom(buffer.storage_,
        count: buffer.backIndex_)
    }
    
    backIndex_ = buffer.count
  }
  
  deinit {
    removeAll()
  }
  
  subscript(index: Int) -> Element {
    get {
      let i = (frontIndex_ &+ index) & (capacity_ &- 1)
      return storage_[i]
    } set {
      let i = (frontIndex_ &+ index) & (capacity_ &- 1)
      storage_[i] = newValue
    }
  }
  
  func reserveCapacity(minimumCapacity: Int) {
    if minimumCapacity <= capacity_ {
      return
    }
    
    var capacity = max(2, minimumCapacity)
    if !isPowerOfTwo(capacity) {
      capacity = nearestPowerOfTwo(capacity)
    }
    
    // allocate new storage
    let newStorage = Storage.alloc(capacity)
    
    // move elements
    if frontIndex_ <= backIndex_ {
      newStorage.moveInitializeFrom(storage_ + frontIndex_, count: count)
    } else {
      // move head elements
      let frontCount = capacity_ - frontIndex_
      newStorage.moveInitializeFrom(storage_ + frontIndex_, count: frontCount)
      
      // move tail elements
      (newStorage + frontCount).moveInitializeFrom(storage_, count: backIndex_)
    }
    
    // update members
    backIndex_ = count
    frontIndex_ = 0
    
    storage_.dealloc(capacity_)
    storage_ = newStorage
    
    capacity_ = capacity
  }
  
  func append(newElement: Element) {
    if capacity_ <= count + 1 {
      reserveCapacity(max(2, capacity_ << 1))
    }
    
    (storage_ + backIndex_).initialize(newElement)
    backIndex_ = (backIndex_ &+ 1) & (capacity_ &- 1)
  }
  
  func prepend(newElement: Element) {
    if capacity_ <= count + 1 {
      reserveCapacity(max(2, capacity_ << 1))
    }
    
    frontIndex_ = (frontIndex_ &- 1) & (capacity &- 1)
    (storage_ + frontIndex_).initialize(newElement)
  }
  
  func removeAll(keepCapacity keepCapacity: Bool = false) {
    if capacity == 0 {
      return
    }
    
    if frontIndex_ <= backIndex_ {
      (storage_ + frontIndex_).destroy(count)
    } else {
      // destroy tail
      storage_.destroy(backIndex_)
      
      // destroy head
      let frontCount = capacity_ &- frontIndex_
      (storage_ + frontIndex_).destroy(frontCount)
    }
    
    frontIndex_ = 0
    backIndex_ = 0
    
    if !keepCapacity {
      storage_.dealloc(capacity_)
      capacity_ = 0
    }
  }
  
  func removeFirst() -> Element {
    let element = (storage_ + frontIndex_).move()
    frontIndex_ = (frontIndex_ &+ 1) & (capacity_ &- 1)
    return element
  }
  
  func removeFirst(count: Int) {
    let newFrontIndex = (frontIndex_ &+ count) & (capacity_ &- 1)
    if frontIndex_ <= newFrontIndex {
      (storage_ + frontIndex_).destroy(count)
    } else {
      // destroy tail
      storage_.destroy(newFrontIndex)
      
      // destroy head
      let frontCount = capacity_ &- frontIndex_
      (storage_ + frontIndex_).destroy(frontCount)
    }
    
    frontIndex_ = newFrontIndex
  }
  
  func removeLast() -> Element {
    backIndex_ = (backIndex_ &- 1) & (capacity_ &- 1)
    return (storage_ + backIndex_).move()
  }
  
  func removeLast(count: Int) {
    let newBackIndex = (backIndex_ &- count) & (capacity_ &- 1)
    if newBackIndex <= backIndex_ {
      (storage_ + newBackIndex).destroy(count)
    } else {
      // destroy tail
      storage_.destroy(backIndex_)
      
      // destroy head
      let frontCount = capacity_ &- newBackIndex
      (storage_ + newBackIndex).destroy(frontCount)
    }
    
    backIndex_ = newBackIndex
  }
  
  func withUnsafeBufferPointer<R>(
    @noescape body: (UnsafeBufferPointer<Element>) throws -> R
  ) rethrows -> R {
    unwrap()
    
    let pointer = UnsafeBufferPointer(start: storage_ + frontIndex_,
      count: count)
    
    return try body(pointer)
  }
  
  func withUnsafeMutableBufferPointer<R>(
    @noescape body: (UnsafeMutableBufferPointer<Element>) throws -> R
  ) rethrows -> R {
    unwrap()
    
    let pointer = UnsafeMutableBufferPointer(start: storage_ + frontIndex_,
      count: count)
    
    defer {
      precondition(pointer.baseAddress == storage_ && pointer.count == count,
        "replacing the storage is not allowed")
    }
    return try body(pointer)
  }
  
  var capacity: Int {
    return capacity_
  }
  
  var count: Int {
    return (backIndex_ &- frontIndex_) & (capacity_ &- 1)
  }
  
  /// Unwraps the buffer.
  func unwrap() {
    if frontIndex_ <= backIndex_ {
      return
    }
    
    // move tail elements
    let frontCount = capacity_ - frontIndex_
    (storage_ + frontCount).moveInitializeBackwardFrom(storage_,
      count: backIndex_)
    
    // move head elements
    storage_.moveInitializeFrom(storage_ + frontIndex_, count: frontCount)
    
    backIndex_ = count
    frontIndex_ = 0
  }
  
  var capacity_: Int = 0
  
  var storage_: Storage
  
  var frontIndex_: Int = 0
  
  var backIndex_: Int = 0
}
