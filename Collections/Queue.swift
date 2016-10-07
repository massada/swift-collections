//
// Queue.swift
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

/// A fast, *collection* where `Element`s are kept in order. Supports adding an
/// element to the head and removing the oldest added element from the front.
public struct Queue<Element> : ExpressibleByArrayLiteral {
  typealias Storage = ArrayDeque<Element>
  
  /// Constructs an empty `Queue`.
  public init() {
    storage_ = Storage()
  }
  
  /// Constructs from an `Array` literal.
  public init(arrayLiteral elements: Element...) {
    storage_ = Storage(elements)
  }
  
  /// Constructs from an arbitrary sequence with elements of type `Element`.
  public init<S : Sequence>(_ sequence: S) where S.Iterator.Element == Element {
    storage_ = Storage(sequence)
  }
  
  /// The elements storage.
  var storage_: Storage
}

extension Queue : QueueType {
  /// Returns the number of elements.
  public var count: Int {
    return storage_.count
  }
  
  /// Clears `self`, removing all elements.
  public mutating func clear() {
    storage_.removeAll()
  }
  
  /// Enqueues `newElement` to `self`.
  ///
  /// - Complexity: amortised O(1).
  public mutating func enqueue(_ newElement: Element) {
    storage_.append(newElement)
  }
  
  /// Dequeues the oldest added element of `self` and returns it.
  ///
  /// - Complexity: O(1).
  /// - Requires: `self.count > 0`.
  public mutating func dequeue() -> Element {
    precondition(count > 0)
    return storage_.removeFirst()
  }
  
  /// Returns the oldest added element of `self`, or `nil` if `self` is
  /// empty.
  public var front: Element? {
    return storage_.first
  }
}

extension Queue : Sequence {
  /// A type that provides the `Queue`'s iteration interface and
  /// encapsulates its iteration state.
  public typealias Iterator = Storage.Iterator
  
  /// Return a *generator* over the elements of the `Queue`.
  ///
  /// - Complexity: O(1).
  public func makeIterator() -> Iterator {
    return storage_.makeIterator()
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
public func ==<Element : Equatable>(
  lhs: Queue<Element>, rhs: Queue<Element>
) -> Bool {
    return lhs.storage_ == rhs.storage_
}

/// Returns `true` if these queues do not contain the same elements.
public func !=<Element : Equatable>(
  lhs: Queue<Element>, rhs: Queue<Element>
) -> Bool {
  return lhs.storage_ != rhs.storage_
}
