//
//  Stack.swift
//  Collections
//
//  Created by José Massada on 24/01/2016.
//  Copyright © 2016 José Massada. All rights reserved.
//

/// A fast, *collection* of `Element` that supports adding an element and
/// removing the most recently added element.
public struct Stack<Element> : ArrayLiteralConvertible {
  typealias Storage = CircularArray<Element>
  
  /// Constructs an empty `Stack`.
  public init() {
    storage_ = Storage()
  }
  
  /// Constructs from an `Array` literal.
  public init(arrayLiteral elements: Element...) {
    storage_ = Storage(minimumCapacity: elements.count)
    for element in elements {
      storage_.prepend(element)
    }
  }
  
  /// Constructs from an arbitrary sequence with elements of type `Element`.
  public init<
    S : SequenceType where S.Generator.Element == Element
  >(_ sequence: S) {
    storage_ = Storage(minimumCapacity: sequence.underestimateCount())
    for element in sequence {
      storage_.prepend(element)
    }
  }
  
  /// The elements storage.
  var storage_: Storage
}

extension Stack : StackType {
  /// Returns the number of elements.
  ///
  /// - Complexity: O(1).
  public var count: Int {
    return storage_.count
  }
  
  /// Clears `Stack`, removing all elements.
  ///
  /// - Complexity: O(1).
  public mutating func clear() {
    storage_.removeAll()
  }
  
  /// Pushes `newElement` to `self`.
  ///
  /// - Complexity: amortised O(1).
  public mutating func push(newElement: Element) {
    storage_.prepend(newElement)
  }
  
  /// Pops the most recently added element of `self` and returns it.
  ///
  /// - Compexity: O(1).
  @warn_unused_result
  public mutating func pop() -> Element {
    return storage_.removeFirst()
  }
  
  /// Returns the most recently added element of the `Stack`, or `nil` if
  /// `self` is empty.
  public var top: Element? {
    return storage_.first
  }
}

extension Stack : SequenceType {
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

extension Stack : CustomStringConvertible, CustomDebugStringConvertible {
  /// A textual representation of `self`.
  public var description: String {
    return storage_.description
  }
  
  /// A textual representation of `self`, suitable for debugging.
  public var debugDescription: String {
    return "Stack(\(description))"
  }
}

/// Returns `true` if these stacks contain the same elements.
@warn_unused_result
public func ==<Element : Equatable>(
  lhs: Stack<Element>, rhs: Stack<Element>
) -> Bool {
  return lhs.storage_ == rhs.storage_
}

/// Returns `true` if these stacks do not contain the same elements.
@warn_unused_result
public func !=<Element : Equatable>(
  lhs: Stack<Element>, rhs: Stack<Element>
) -> Bool {
  return lhs.storage_ != rhs.storage_
}
