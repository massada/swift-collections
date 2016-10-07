//
// ArrayDeque.swift
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

/// A fast, double-ended queue of `Element` implemented with a modified dynamic
/// array.
public struct ArrayDeque<Element> : ExpressibleByArrayLiteral {
  typealias Storage = ArrayDequeBuffer<Element>
  
  /// Constructs an empty `ArrayDeque`.
  public init() {
    storage_ = Storage()
  }
  
  /// Constructs with at least the given number of elements worth of storage.
  public init(minimumCapacity: Int) {
    storage_ = Storage(minimumCapacity: minimumCapacity)
  }
  
  /// Constructs from an `Array` literal.
  public init(arrayLiteral elements: Element...) {
    storage_ = Storage(minimumCapacity: elements.count)
    for element in elements {
      storage_.append(element)
    }
  }
  
  /// Constructs from an arbitrary sequence with elements of type `Element`.
  public init<
    S : Sequence>(_ sequence: S) where S.Iterator.Element == Element
   {
    storage_ = Storage(minimumCapacity: sequence.underestimatedCount)
    for element in sequence {
      storage_.append(element)
    }
  }
  
  /// The storage capacity.
  public var capacity: Int {
    return storage_.capacity
  }
  
  /// The elements storage.
  var storage_: Storage
}

extension ArrayDeque : DequeCollectionType {
  /// Reserve enough space to store `minimumCapacity` elements.
  ///
  /// - Postcondition: `capacity >= minimumCapacity` and the array deque has
  ///   mutable contiguous storage.
  ///
  /// - Complexity: O(`self.count`).
  public mutating func reserveCapacity(_ minimumCapacity: Int) {
    makeUniqueMutableStorage()
    storage_.reserveCapacity(minimumCapacity)
  }
  
  /// Prepends `newElement` to the `ArrayDeque`.
  ///
  /// Invalidates all indices with respect to `self`.
  ///
  /// - Complexity: amortized O(1).
  public mutating func prepend(_ newElement: Element) {
    makeUniqueMutableStorage()
    storage_.prepend(newElement)
  }
  
  /// Prepends the elements of `newElements` to the `ArrayDeque`.
  ///
  /// - Complexity: O(*length of `newElements`*).
  public mutating func prependContentsOf<
    S : Sequence>(_ newElements: S) where S.Iterator.Element == Element
   {
    reserveCapacity(newElements.underestimatedCount)
    for element in newElements.reversed() {
      storage_.prepend(element)
    }
  }
  
  /// Prepends the elements of `newElements` to the `ArrayDeque`.
  ///
  /// - Complexity: O(*length of `newElements`*).
  public mutating func prependContentsOf<
    C : Collection>(_ newElements: C) where C.Iterator.Element == Element
   {
    reserveCapacity(numericCast(newElements.count))
    for element in newElements.reversed() {
      storage_.prepend(element)
    }
  }
  
  /// Appends `newElement` to the `ArrayDeque`.
  ///
  /// Applying `successor()` to the index of the new element yields
  /// `self.endIndex`.
  ///
  /// - Complexity: amortized O(1).
  public mutating func append(_ newElement: Element) {
    makeUniqueMutableStorage()
    storage_.append(newElement)
  }
  
  /// Appends the elements of `newElements` to the `ArrayDeque`.
  ///
  /// - Complexity: O(*length of `newElements`*).
  public mutating func appendContentsOf<
    S : Sequence>(_ newElements: S) where S.Iterator.Element == Element
   {
    reserveCapacity(newElements.underestimatedCount)
    for element in newElements {
      storage_.append(element)
    }
  }
  
  /// Appends the elements of `newElements` to the `ArrayDeque`.
  ///
  /// - Complexity: O(*length of `newElements`*).
  public mutating func appendContentsOf<
    C : Collection>(_ newElements: C) where C.Iterator.Element == Element
   {
    reserveCapacity(numericCast(newElements.count))
    for element in newElements {
      storage_.append(element)
    }
  }
  
  /// Removes the element at `startIndex` and returns it.
  ///
  /// - Complexity: O(1).
  /// - Requires: `self.count > 0`.
  public mutating func removeFirst() -> Element {
    precondition(count > 0, "can't remove items from an empty collection")
    
    makeUniqueMutableStorage()
    return storage_.removeFirst()
  }
  
  /// Removes the first `n` elements.
  ///
  /// - Complexity: O(`n`).
  /// - Requires: `n >= 0 && self.count >= n`.
  public mutating func removeFirst(_ n: Int) {
    if n == 0 {
      return
    }
    
    precondition(n >= 0, "number of elements to remove should be non-negative")
    precondition(count >= n,
      "can't remove more items from a collection than it contains")
    
    makeUniqueMutableStorage()
    storage_.removeFirst(n)
  }
  
  /// Removes the element at the end and returns it.
  ///
  /// - Complexity: O(1).
  /// - Requires: `count > 0`.
  public mutating func removeLast() -> Element {
    precondition(count > 0, "can't remove items from an empty collection")
    
    makeUniqueMutableStorage()
    return storage_.removeLast()
  }
  
  /// Removes the last `n` elements.
  ///
  /// - Complexity: O(`n`).
  /// - Requires: `n >= 0 && self.count >= n`.
  public mutating func removeLast(_ n: Int) {
    if n == 0 {
      return
    }
    
    precondition(n >= 0, "number of elements to remove should be non-negative")
    precondition(count >= n,
      "can't remove more items from a collection than it contains")
    
    makeUniqueMutableStorage()
    storage_.removeLast(n)
  }
  
  /// Removes all elements.
  ///
  /// Invalidates all indices with respect to `self`.
  ///
  /// - Parameter keepCapacity: if `true`, is a non-binding request to
  ///   avoid releasing storage, which can be a useful optimization
  ///   when `self` is going to be grown again.
  ///
  /// - Postcondition: `capacity == 0` if `keepCapacity` is `false`.
  ///
  /// - Complexity: O(`self.count`).
  public mutating func removeAll(keepCapacity: Bool = false) {
    if !isKnownUniquelyReferenced(&storage_) {
      let capacity = (keepCapacity) ? storage_.capacity : 0
      storage_ = Storage(minimumCapacity: capacity)
    } else {
      storage_.removeAll(keepCapacity: keepCapacity)
    }
  }
  
  /// Creates a new storage if this array deque is not backed by a
  /// uniquely-referenced mutable storage.
  mutating func makeUniqueMutableStorage() {
    if !isKnownUniquelyReferenced(&storage_) {
      storage_ = Storage(buffer: storage_)
    }
  }
}

extension ArrayDeque : BidirectionalCollection, MutableCollection {
  /// A type that represents a valid position in the collection.
  ///
  /// Valid indices consist of the position of every element and a
  /// "past the end" position that's not valid for use as a subscript.
  public typealias Index = Int
  
  /// The position of the first element in a non-empty collection.
  ///
  /// In an empty collection, `startIndex == endIndex`.
  public var startIndex: Index {
    return 0
  }
  
  /// A "past-the-end" element index; the successor of the last valid
  /// subscript argument.
  public var endIndex: Index {
    return storage_.count
  }
  
  /// Access the `index`th element.
  ///
  /// - Complexity: O(1).
  public subscript(index: Index) -> Element {
    get {
      checkIndex(index)
      return storage_[index]
    } set {
      checkIndex(index)
      makeUniqueMutableStorage()
      storage_[index] = newValue
    }
  }
  
  public subscript(bounds: Range<Index>) -> BidirectionalSlice<ArrayDeque> {
    get {
      fatalError()
    } set {
      fatalError()
    }
  }
  
  /// Returns the position immediately after the given index.
  ///
  /// - Parameter i: A valid index of the collection. `i` must be less than
  ///   `endIndex`.
  /// - Returns: The index value immediately after `i`.
  public func index(after i: Index) -> Index {
    checkIndex(i)
    return i + 1
  }
  
  /// Returns the position immediately before the given index.
  ///
  /// - Parameter i: A valid index of the collection. `i` must be greater than
  ///   `startIndex`.
  /// - Returns: The index value immediately before `i`.
  public func index(before i: Index) -> Index {
    checkIndex(i)
    return i - 1
  }
  
  /// Checks that the given `index` is valid.
  func checkIndex(_ index: Index) {
    precondition(index >= startIndex && index <= endIndex, "index out of range")
  }
}

extension ArrayDeque : CustomStringConvertible, CustomDebugStringConvertible {
  /// A textual representation of `self`.
  public var description: String {
    return Array(self).description
  }
  
  /// A textual representation of `self`, suitable for debugging.
  public var debugDescription: String {
    return "ArrayDeque(\(description))"
  }
}

/// Returns `true` if these array deques contain the same elements.
public func ==<Element : Equatable>(
  lhs: ArrayDeque<Element>, rhs: ArrayDeque<Element>
) -> Bool {
  return lhs.elementsEqual(rhs)
}

/// Returns `true` if these array deques do not contain the same elements.
public func !=<Element : Equatable>(
  lhs: ArrayDeque<Element>, rhs: ArrayDeque<Element>
) -> Bool {
  return !lhs.elementsEqual(rhs)
}
