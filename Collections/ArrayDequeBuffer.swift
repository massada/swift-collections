//
// ArrayDequeBuffer.swift
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

class ArrayDequeBuffer<Element> {
  typealias Storage = UnsafeMutablePointer<Element>
  
  init() {
    storage_ = nil
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
    storage_ = Storage.allocate(capacity: capacity_)
  }
  
  init(buffer: ArrayDequeBuffer) {
    capacity_ = buffer.capacity
    storage_ = Storage.allocate(capacity: capacity_)
    
    if buffer.frontIndex_ <= buffer.backIndex_ {
      storage_?.initialize(
        from: buffer.storage_! + buffer.frontIndex_, count: buffer.count)
    } else {
      // initialise head elements
      let frontCount = buffer.capacity_ &- buffer.frontIndex_
      storage_?.initialize(
        from: buffer.storage_! + buffer.frontIndex_, count: frontCount)
      
      // initialise tail elements
      (storage_! + frontCount).initialize(
        from: buffer.storage_!, count: buffer.backIndex_)
    }
    
    backIndex_ = buffer.count
  }
  
  deinit {
    removeAll()
  }
  
  subscript(index: Int) -> Element {
    get {
      let i = (frontIndex_ &+ index) & (capacity_ &- 1)
      return storage_![i]
    } set {
      let i = (frontIndex_ &+ index) & (capacity_ &- 1)
      storage_?[i] = newValue
    }
  }
  
  func reserveCapacity(_ minimumCapacity: Int) {
    if minimumCapacity <= capacity_ {
      return
    }
    
    var capacity = max(2, minimumCapacity)
    if !isPowerOfTwo(capacity) {
      capacity = nearestPowerOfTwo(capacity)
    }
    
    // allocate new storage
    let newStorage = Storage.allocate(capacity: capacity)
    
    if (storage_ != nil) {
      // move elements
      if frontIndex_ <= backIndex_ {
        newStorage.moveInitialize(from: storage_! + frontIndex_, count: count)
      } else {
        // move head elements
        let frontCount = capacity_ - frontIndex_
        newStorage.moveInitialize(
          from: storage_! + frontIndex_, count: frontCount)
        
        // move tail elements
        (newStorage + frontCount).moveInitialize(
          from: storage_!, count: backIndex_)
      }
      
      // update members
      backIndex_ = count
      frontIndex_ = 0
      
      if capacity_ > 0 {
        storage_?.deallocate(capacity: capacity_)
      }
    }
    
    storage_ = newStorage
    capacity_ = capacity
  }
  
  func append(_ newElement: Element) {
    if capacity_ <= count + 1 {
      reserveCapacity(max(2, capacity_ << 1))
    }
    
    (storage_! + backIndex_).initialize(to: newElement)
    backIndex_ = (backIndex_ &+ 1) & (capacity_ &- 1)
  }
  
  func prepend(_ newElement: Element) {
    if capacity_ <= count + 1 {
      reserveCapacity(max(2, capacity_ << 1))
    }
    
    frontIndex_ = (frontIndex_ &- 1) & (capacity &- 1)
    (storage_! + frontIndex_).initialize(to: newElement)
  }
  
  func removeAll(keepCapacity: Bool = false) {
    if capacity == 0 {
      return
    }
    
    if frontIndex_ <= backIndex_ {
      (storage_! + frontIndex_).deinitialize(count: count)
    } else {
      // destroy tail
      storage_?.deinitialize(count: backIndex_)
      
      // destroy head
      let frontCount = capacity_ &- frontIndex_
      (storage_! + frontIndex_).deinitialize(count: frontCount)
    }
    
    frontIndex_ = 0
    backIndex_ = 0
    
    if !keepCapacity {
      storage_?.deallocate(capacity: capacity_)
      capacity_ = 0
    }
  }
  
  func removeFirst() -> Element {
    let element = (storage_! + frontIndex_).move()
    frontIndex_ = (frontIndex_ &+ 1) & (capacity_ &- 1)
    return element
  }
  
  func removeFirst(_ count: Int) {
    let newFrontIndex = (frontIndex_ &+ count) & (capacity_ &- 1)
    if frontIndex_ <= newFrontIndex {
      (storage_! + frontIndex_).deinitialize(count: count)
    } else {
      // destroy tail
      storage_?.deinitialize(count: newFrontIndex)
      
      // destroy head
      let frontCount = capacity_ &- frontIndex_
      (storage_! + frontIndex_).deinitialize(count: frontCount)
    }
    
    frontIndex_ = newFrontIndex
  }
  
  func removeLast() -> Element {
    backIndex_ = (backIndex_ &- 1) & (capacity_ &- 1)
    return (storage_! + backIndex_).move()
  }
  
  func removeLast(_ count: Int) {
    let newBackIndex = (backIndex_ &- count) & (capacity_ &- 1)
    if newBackIndex <= backIndex_ {
      (storage_! + newBackIndex).deinitialize(count: count)
    } else {
      // destroy tail
      storage_?.deinitialize(count: backIndex_)
      
      // destroy head
      let frontCount = capacity_ &- newBackIndex
      (storage_! + newBackIndex).deinitialize(count: frontCount)
    }
    
    backIndex_ = newBackIndex
  }
  
  var capacity: Int {
    return capacity_
  }
  
  var count: Int {
    return (backIndex_ &- frontIndex_) & (capacity_ &- 1)
  }
  
  var capacity_: Int = 0
  
  var storage_: Storage?
  
  var frontIndex_: Int = 0
  
  var backIndex_: Int = 0
}
