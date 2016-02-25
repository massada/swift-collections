//
//  QueueType.swift
//  Collections
//
//  Created by José Massada on 26/01/2016.
//  Copyright © 2016 José Massada. All rights reserved.
//

/// A *collection* where elements are kept in order. Supports adding an element
/// to the head and removing the oldest added element from the front.
public protocol QueueType : SequenceType, ArrayLiteralConvertible {
  /// Returns the number of elements.
  var count: Int { get }
  
  /// Returns `true` if `self` is empty.
  var isEmpty: Bool { get }
  
  /// Clears `self`, removing all elements.
  mutating func clear()
  
  /// Enqueues `newElement` to `self`.
  mutating func enqueue(newElement: Generator.Element)
  
  /// Dequeues the oldest added element of `self` and returns it.
  ///
  /// - Requires: `self.count > 0`.
  @warn_unused_result
  mutating func dequeue() -> Generator.Element
  
  /// Returns the oldest added element of `self`, or `nil` if `self` is
  /// empty.
  var front: Generator.Element? { get }
}

// Default implementations
extension QueueType {
  public var isEmpty: Bool {
    return count == 0
  }
}
