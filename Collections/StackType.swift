//
//  StackType.swift
//  Collections
//
//  Created by José Massada on 26/01/2016.
//  Copyright © 2016 José Massada. All rights reserved.
//

/// A *collection* that supports adding an element and removing the most
/// recently added element.
public protocol StackType : SequenceType, ArrayLiteralConvertible {
  /// Returns the number of elements.
  var count: Int { get }
  
  /// Returns `true` if `self` is empty.
  var isEmpty: Bool { get }
  
  /// Clears `self`, removing all elements.
  mutating func clear()
  
  /// Pushes `newElement` to `self`.
  mutating func push(newElement: Generator.Element)
  
  /// Pops the most recently added element of `self` and returns it.
  @warn_unused_result
  mutating func pop() -> Generator.Element
  
  /// Returns the most recently added element of `self`, or `nil` if `self` is
  /// empty.
  var top: Generator.Element? { get }
}

// Default implementations
extension StackType {
  public var isEmpty: Bool {
    return count == 0
  }
}
