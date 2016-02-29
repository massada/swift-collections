//
//  HeapType.swift
//  Collections
//
//  Created by José Massada on 25/02/2016.
//  Copyright © 2016 massada. All rights reserved.
//

/// A *collection* where elements are kept in order.
public protocol HeapType : SequenceType, ArrayLiteralConvertible {
  /// The type of element.
  typealias Element : Comparable
  
  /// Returns the number of elements.
  var count: Int { get }
  
  /// Returns `true` if `self` is empty.
  var isEmpty: Bool { get }
  
  /// Clears `self`, removing all elements.
  mutating func clear()
  
  /// Enqueues `newElement` to `self` while keeping priority order.
  mutating func enqueue(newElement: Generator.Element)
  
  /// Dequeues the highest/lowest priority element of `self` and returns it.
  ///
  /// - Requires: `self.count > 0`.
  @warn_unused_result
  mutating func dequeue() -> Generator.Element
  
  /// Returns the highest/lowest priority element of `self`, or `nil` if
  /// `self` is empty.
  var front: Generator.Element? { get }
}

// Default implementations
extension HeapType {
  public var isEmpty: Bool {
    return count == 0
  }
}
