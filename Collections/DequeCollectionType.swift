//
// DequeCollectionType.swift
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

/// A *collection* that supports adding or removing elements from either the
/// front or back.
public protocol DequeCollectionType
  : BidirectionalCollection, MutableCollection, ExpressibleByArrayLiteral
{
  /// A type that represents a valid position in the collection.
  ///
  /// Valid indices consist of the position of every element and a
  /// "past the end" position that's not valid for use as a subscript.
  ///
  /// - Note: This associated type appears as a requirement in `Indexable`, but
  ///   is restated here with stricter constraints: in a `DequeCollectionType`,
  ///   the `Index` should also be a `BidirectionalIndexType`.
  associatedtype Index : Comparable
  
  /// A non-binding request to ensure `n` elements of available storage.
  ///
  /// This works as an optimization to avoid multiple reallocations of
  /// linear data structures like `CircularArray`.  Conforming types may
  /// reserve more than `n`, exactly `n`, less than `n` elements of
  /// storage, or even ignore the request completely.
  mutating func reserveCapacity(_ minimumCapacity: Int)
  
  /// Prepends `newElement` to `self`.
  ///
  /// Invalidates all indices with respect to `self`.
  mutating func prepend(_ newElement: Iterator.Element)
  
  /// Prepends the elements of `newElements` to `self`.
  ///
  /// - Complexity: O(*length of `newElements`*).
  mutating func prependContentsOf<S : Sequence>(_ newElements: S)
    where S.Iterator.Element == Iterator.Element
  
  /// Appends `newElement` to `self`.
  ///
  /// Applying `successor()` to the index of the new element yields
  /// `self.endIndex`.
  mutating func append(_ newElement: Iterator.Element)
  
  /// Appends the elements of `newElements` to `self`.
  ///
  /// - Complexity: O(*length of `newElements`*).
  mutating func appendContentsOf<S : Sequence>(_ newElements: S)
    where S.Iterator.Element == Iterator.Element
  
  /// Removes the element at `startIndex` and returns it.
  ///
  /// - Requires: `!self.isEmpty`.
  mutating func removeFirst() -> Iterator.Element
  
  /// Removes the first `n` elements.
  ///
  /// - Complexity: O(`n`).
  /// - Requires: `n >= 0 && self.count >= n`.
  mutating func removeFirst(_ n: Int)
  
  /// Removes the element at the end and returns it.
  ///
  /// - Requires: `!self.isEmpty`
  mutating func removeLast() -> Iterator.Element
  
  /// Removes the last `n` elements.
  ///
  /// - Complexity: O(`n`).
  /// - Requires: `n >= 0 && self.count >= n`.
  mutating func removeLast(_ n: Int)
  
  /// Removes all elements.
  ///
  /// Invalidates all indices with respect to `self`.
  ///
  /// - Parameter keepCapacity: If `true`, is a non-binding request to
  ///   avoid releasing storage, which can be a useful optimization
  ///   when `self` is going to be grown again.
  ///
  /// - Complexity: O(`self.count`).
  mutating func removeAll(keepCapacity: Bool)
}

// Default implementations
extension DequeCollectionType {
  public mutating func reserveCapacity(_ minimumCapacity: Int) {
  }
  
  public mutating func prependContentsOf<S : Sequence>(_ newElements: S)
    where S.Iterator.Element == Iterator.Element {
    for element in newElements.reversed() {
      prepend(element)
    }
  }
  
  public mutating func appendContentsOf<S : Sequence>(_ newElements: S)
    where S.Iterator.Element == Iterator.Element {
    for element in newElements {
      append(element)
    }
  }
  
  public mutating func removeFirst(_ n: Int) {
    if n == 0 {
      return
    }
    
    precondition(n >= 0, "number of elements to remove should be non-negative")
    precondition(
      count >= numericCast(n),
      "can't remove more items from a collection than it contains")
    
    for _ in 0..<n {
      _ = removeFirst()
    }
  }
  
  public mutating func removeLast(_ n: Int) {
    if n == 0 {
      return
    }
    
    precondition(n >= 0, "number of elements to remove should be non-negative")
    precondition(
      count >= numericCast(n),
      "can't remove more items from a collection than it contains")
    
    for _ in 0..<n {
      _ = removeLast()
    }
  }
  
  public mutating func removeAll(keepCapacity: Bool = false) {
    if !keepCapacity {
      self = Self()
    }
    else {
      removeFirst(numericCast(self.count))
    }
  }
}

extension DequeCollectionType where SubSequence == Self {
  /// Removes the element at `startIndex` and return it.
  ///
  /// - Complexity: O(1).
  /// - Requires: `!self.isEmpty`.
  
  public mutating func removeFirst() -> Iterator.Element {
    precondition(!isEmpty, "can't remove items from an empty collection")
    
    let element = first!
    self = self[index(after: startIndex)..<endIndex]
    return element
  }
  
  /// Removes the first `n` elements.
  ///
  /// - Complexity: O(1).
  /// - Requires: `n >= 0 && self.count >= n`.
  public mutating func removeFirst(_ n: Int) {
    if n == 0 {
      return
    }
    
    precondition(n >= 0, "number of elements to remove should be non-negative")
    precondition(
      count >= numericCast(n),
      "can't remove more items from a collection than it contains")
    
    self = self[index(startIndex, offsetBy: numericCast(n))..<endIndex]
  }
  
  /// Removes the element at the end and returns it.
  ///
  /// - Complexity: O(1).
  /// - Requires: `!self.isEmpty`.
  
  public mutating func removeLast() -> Iterator.Element {
    precondition(!isEmpty, "can't remove items from an empty collection")
    
    let element = first!
    self = self[startIndex..<index(before: endIndex)]
    return element
  }
  
  /// Removes the last `n` elements.
  ///
  /// - Complexity: O(1).
  /// - Requires: `n >= 0 && self.count >= n`.
  public mutating func removeLast(_ n: Int) {
    if n == 0 {
      return
    }
    
    precondition(n >= 0, "number of elements to remove should be non-negative")
    precondition(
      count >= numericCast(n),
      "can't remove more items from a collection than it contains")
    
    self = self[startIndex..<index(endIndex, offsetBy: -numericCast(n))]
  }
}
