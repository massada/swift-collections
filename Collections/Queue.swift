//
//  Queue.swift
//  Collections
//
//  Created by José Massada on 23/01/2016.
//  Copyright © 2016 José Massada. All rights reserved.
//

/// A fast, *collection* where `Element`s are kept in order. Supports adding an
/// element to the head and removing the oldest added element from the front.
public struct Queue<Element> : ArrayLiteralConvertible {
  typealias Storage = CircularArray<Element>
  
  // Create an empty queue
  public init() {
    storage_ = Storage()
  }
  
  // Create a Queue from an Array literal
  public init(arrayLiteral elements: Element...) {
    storage_ = Storage(elements)
  }
  
  // Create a Queue from a finite sequence of items
  public init<
    S : SequenceType where S.Generator.Element == Element
  >(_ sequence: S) {
    storage_ = Storage(sequence)
  }
  
  // The elements storage
  var storage_: Storage
}

extension Queue : QueueType {
  /// Returns the number of elements.
  public var count: Int {
    return storage_.count
  }
  
  /// Clears the `Queue`, removing all elements.
  ///
  /// - Complexity: O(1).
  public mutating func clear() {
    storage_.removeAll()
  }
  
  /// Enqueues `newElement` to `self`.
  ///
  /// - Complexity: amortised O(1).
  public mutating func enqueue(newElement: Element) {
    storage_.append(newElement)
  }
  
  /// Dequeues the oldest added element of `self` and returns it.
  ///
  /// - Complexity: O(1).
  @warn_unused_result
  public mutating func dequeue() -> Element {
    return storage_.removeFirst()
  }
  
  /// Returns the oldest added element of `self`, or `nil` if `self` is
  /// empty.
  public var front: Element? {
    return storage_.first
  }
}

extension Queue : SequenceType {
  /// A type that provides the `Stack`'s iteration interface and
  /// encapsulates its iteration state.
  public typealias Generator = Storage.Generator
  
  /// Return a *generator* over the elements of the `Stack`.
  ///
  /// - Complexity: O(1).
  @warn_unused_result
  public func generate() -> Generator {
    return storage_.generate()
  }
}

extension Queue : CustomStringConvertible, CustomDebugStringConvertible {
  /// A textual representation of `self`.
  public var description: String {
    return storage_.description
  }
  
  /// A textual representation of `self`, suitable for debugging.
  public var debugDescription: String {
    return "Queue(\(description))"
  }
}

/// Returns `true` if these queues contain the same elements.
@warn_unused_result
public func ==<Element : Equatable>(
  lhs: Queue<Element>, rhs: Queue<Element>
) -> Bool {
    return lhs.storage_ == rhs.storage_
}

/// Returns `true` if these queues do not contain the same elements.
@warn_unused_result
public func !=<Element : Equatable>(
  lhs: Queue<Element>, rhs: Queue<Element>
) -> Bool {
  return lhs.storage_ != rhs.storage_
}
