//
//  PriorityQueue.swift
//  Collections
//
//  Created by José Massada on 25/02/2016.
//  Copyright © 2016 massada. All rights reserved.
//

/// A *collection* where `Element`s are kept ordered.
public struct PriorityQueue<Element : Comparable> : ArrayLiteralConvertible {
  typealias Storage = CircularArray<Element>
  
  /// Constructs an empty `PriorityQueue` that orders its elements according
  /// to their natural ordering.
  public init() {
    self.init(isOrdered: <)
  }
  
  /// Constructs a `PriorityQueue` that orders its elements according
  /// to the result of calling `isOrdered`.
  public init(isOrdered: (Element, Element) -> Bool) {
    storage_ = Storage()
    isOrdered_ = isOrdered
  }
  
  /// Constructs from an `Array` literal.
  ///
  /// - Complexity: O(n).
  public init(arrayLiteral elements: Element...) {
    self.init(elements)
  }
  
  /// Constructs from an arbitrary sequence with elements of type `Element`
  /// ordering according to the elements natural order.
  public init<
    S : SequenceType where S.Generator.Element == Element
  >(_ sequence: S) {
    self.init(sequence, isOrdered: <)
  }
  
  /// Constructs from an arbitrary sequence with elements of type `Element`
  /// ordering according to the result of calling `isOrdered` over the
  /// elements.
  public init<
    S : SequenceType where S.Generator.Element == Element
  >(_ sequence: S, isOrdered: (Element, Element) -> Bool) {
    storage_ = Storage(sequence)
    isOrdered_ = isOrdered
    
    let endIndex = count >> 1
    for i in (0..<endIndex).reverse() {
      heapifyDown(i)
    }
  }
  
  /// The elements storage.
  var storage_: Storage
  
  /// The ordering function.
  let isOrdered_: (Element, Element) -> Bool
}

extension PriorityQueue : HeapType {
  /// Returns the number of elements.
  public var count: Int {
    return storage_.count
  }
  
  /// Clears `self`, removing all elements.
  public mutating func clear() {
    storage_.removeAll()
  }
  
  /// Enqueues `newElement` to `self` while keeping priority order.
  ///
  /// - Complexity: O(log n).
  public mutating func enqueue(newElement: Element) {
    storage_.append(newElement)
    if count > 1 {
      heapifyUp(storage_.endIndex - 1)
    }
  }
  
  /// Dequeues the highest/lowest priority element of `self` and returns it.
  ///
  /// - Complexity: O(log n).
  /// - Requires: `self.count > 0`.
  @warn_unused_result
  public mutating func dequeue() -> Element {
    precondition(count > 0)
    
    if count == 1 {
      return storage_.removeFirst()
    }
    
    swap(&storage_[0], &storage_[storage_.endIndex - 1])
    
    let element = storage_.removeLast()
    heapifyDown(0)
    return element
  }
  
  /// Returns the highest/lowest priority element of `self`, or `nil` if
  /// `self` is empty.
  public var front: Element? {
    return storage_.first
  }
  
  /// Heapifies-up the storage.
  mutating func heapifyUp(index: Int) {
    let element = storage_[index]
    
    var index = index
    while index > 0 {
      let parentIndex = (index - 1) >> 1
      let parentElement = storage_[parentIndex]
      
      if isOrdered_(parentElement, element) {
        break
      }
      
      storage_[index] = parentElement
      index = parentIndex
    }
    
    storage_[index] = element
  }
  
  /// Heapifies-down the storage.
  mutating func heapifyDown(index: Int) {
    let element = storage_[index]
    
    var index = index
    let endIndex = count >> 1
    
    while index < endIndex {
      var childIndex = (index << 1) + 1
      var childElement = storage_[childIndex]
      
      let rightIndex = childIndex + 1
      if rightIndex < storage_.count &&
        isOrdered_(storage_[rightIndex], childElement)
      {
        childIndex = rightIndex
        childElement = storage_[childIndex]
      }
      
      if !isOrdered_(childElement, element) {
        break
      }
      
      storage_[index] = childElement
      index = childIndex
    }
    
    storage_[index] = element
  }
}

extension PriorityQueue : SequenceType {
  /// A type that provides the `PriorityQueue`'s iteration interface and
  /// encapsulates its iteration state.
  public typealias Generator = Storage.Generator
  
  /// Return a *generator* over the elements of the `PriorityQueue`.
  ///
  /// - Note: The *generator* does not return the elements in any particular
  /// order.
  ///
  /// - Complexity: O(1).
  @warn_unused_result
  public func generate() -> Generator {
    return storage_.generate()
  }
}

extension PriorityQueue
  : CustomStringConvertible, CustomDebugStringConvertible
{
  /// A textual representation of `self`.
  public var description: String {
    return storage_.description
  }
  
  /// A textual representation of `self`, suitable for debugging.
  public var debugDescription: String {
    return "PriorityQueue(\(description))"
  }
}

/// Returns `true` if these priority queues contain the same elements.
@warn_unused_result
public func ==<Element>(
  lhs: PriorityQueue<Element>, rhs: PriorityQueue<Element>
) -> Bool {
  return lhs.storage_ == rhs.storage_
}

/// Returns `true` if these priority queues do not contain the same elements.
@warn_unused_result
public func !=<Element>(
  lhs: PriorityQueue<Element>, rhs: PriorityQueue<Element>
) -> Bool {
  return lhs.storage_ != rhs.storage_
}
