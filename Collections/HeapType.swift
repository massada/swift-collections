//
// HeapType.swift
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

/// A *collection* where elements are kept in order.
public protocol HeapType : SequenceType, ArrayLiteralConvertible {
  /// The type of element.
  associatedtype Element : Comparable
  
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
