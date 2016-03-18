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
public struct ArrayDeque<Element> : ArrayLiteralConvertible {
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
    S : SequenceType where S.Generator.Element == Element
  >(_ sequence: S) {
    storage_ = Storage(minimumCapacity: sequence.underestimateCount())
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
  public mutating func reserveCapacity(minimumCapacity: Int) {
    makeUniqueMutableStorage()
    storage_.reserveCapacity(minimumCapacity)
  }
  
  /// Prepends `newElement` to the `ArrayDeque`.
  ///
  /// Invalidates all indices with respect to `self`.
  ///
  /// - Complexity: amortized O(1).
  public mutating func prepend(newElement: Element) {
    makeUniqueMutableStorage()
    storage_.prepend(newElement)
  }
  
  /// Prepends the elements of `newElements` to the `ArrayDeque`.
  ///
  /// - Complexity: O(*length of `newElements`*).
  public mutating func prependContentsOf<
    S : SequenceType where S.Generator.Element == Element
  >(newElements: S) {
    reserveCapacity(newElements.underestimateCount())
    for element in newElements.reverse() {
      storage_.prepend(element)
    }
  }
  
  /// Prepends the elements of `newElements` to the `ArrayDeque`.
  ///
  /// - Complexity: O(*length of `newElements`*).
  public mutating func prependContentsOf<
    C : CollectionType where C.Generator.Element == Element
    >(newElements: C) {
      reserveCapacity(numericCast(newElements.count))
      for element in newElements.reverse() {
        storage_.prepend(element)
      }
  }
  
  /// Appends `newElement` to the `ArrayDeque`.
  ///
  /// Applying `successor()` to the index of the new element yields
  /// `self.endIndex`.
  ///
  /// - Complexity: amortized O(1).
  public mutating func append(newElement: Element) {
    makeUniqueMutableStorage()
    storage_.append(newElement)
  }
  
  /// Appends the elements of `newElements` to the `ArrayDeque`.
  ///
  /// - Complexity: O(*length of `newElements`*).
  public mutating func appendContentsOf<
    S : SequenceType where S.Generator.Element == Element
  >(newElements: S) {
    reserveCapacity(newElements.underestimateCount())
    for element in newElements {
      storage_.append(element)
    }
  }
  
  /// Appends the elements of `newElements` to the `ArrayDeque`.
  ///
  /// - Complexity: O(*length of `newElements`*).
  public mutating func appendContentsOf<
    C : CollectionType where C.Generator.Element == Element
  >(newElements: C) {
    reserveCapacity(numericCast(newElements.count))
    for element in newElements {
      storage_.append(element)
    }
  }
  
  /// Removes the element at `startIndex` and returns it.
  ///
  /// - Complexity: O(1).
  /// - Requires: `self.count > 0`.
  @warn_unused_result
  public mutating func removeFirst() -> Element {
    precondition(count > 0, "can't remove items from an empty collection")
    
    makeUniqueMutableStorage()
    return storage_.removeFirst()
  }
  
  /// Removes the first `n` elements.
  ///
  /// - Complexity: O(`n`).
  /// - Requires: `n >= 0 && self.count >= n`.
  public mutating func removeFirst(n: Int) {
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
  @warn_unused_result
  public mutating func removeLast() -> Element {
    precondition(count > 0, "can't remove items from an empty collection")
    
    makeUniqueMutableStorage()
    return storage_.removeLast()
  }
  
  /// Removes the last `n` elements.
  ///
  /// - Complexity: O(`n`).
  /// - Requires: `n >= 0 && self.count >= n`.
  public mutating func removeLast(n: Int) {
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
  public mutating func removeAll(keepCapacity keepCapacity: Bool = false) {
    if !isUniquelyReferencedNonObjC(&storage_) {
      let capacity = (keepCapacity) ? storage_.capacity : 0
      storage_ = Storage(minimumCapacity: capacity)
    } else {
      storage_.removeAll(keepCapacity: keepCapacity)
    }
  }
  
  /// Creates a new storage if this array deque is not backed by a
  /// uniquely-referenced mutable storage.
  mutating func makeUniqueMutableStorage() {
    if !isUniquelyReferencedNonObjC(&storage_) {
      storage_ = Storage(buffer: storage_)
    }
  }
}

extension ArrayDeque : Indexable, MutableIndexable {
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
  
  /// Checks that the given `index` is valid.
  func checkIndex(index: Index) {
    precondition(index >= startIndex && index <= endIndex, "index out of range")
  }
}

extension ArrayDeque
  : CustomStringConvertible, CustomDebugStringConvertible {
  
  /// A textual representation of `self`.
  public var description: String {
    return Array(self).description
  }
  
  /// A textual representation of `self`, suitable for debugging.
  public var debugDescription: String {
    return "ArrayDeque(\(description))"
  }
}

extension ArrayDeque {
  /// Call `body(p)`, where `p` is a pointer to the `ArrayDeque`'s
  /// contiguous storage.
  ///
  /// Often, the optimizer can eliminate bounds checks within an
  /// array algorithm, but when that fails, invoking the
  /// same algorithm on `body`'s argument lets you trade safety for
  /// speed.
  public func withUnsafeBufferPointer<R>(
    @noescape body: (UnsafeBufferPointer<Element>) throws -> R
    ) rethrows -> R {
      return try storage_.withUnsafeBufferPointer(body)
  }
  
  /// Call `body(p)`, where `p` is a pointer to the `ArrayDeque`'s
  /// mutable contiguous storage.
  ///
  /// Often, the optimizer can eliminate bounds- and uniqueness-checks
  /// within an array algorithm, but when that fails, invoking the
  /// same algorithm on `body`'s argument lets you trade safety for
  /// speed.
  ///
  /// - Warning: Do not rely on anything about `self` (the `ArrayDeque`
  ///   that is the target of this method) during the execution of
  ///   `body`: it may not appear to have its correct value.  Instead,
  ///   use only the `UnsafeMutableBufferPointer` argument to `body`.
  public mutating func withUnsafeMutableBufferPointer<R>(
    @noescape body: (UnsafeMutableBufferPointer<Element>) throws -> R
    ) rethrows -> R {
      let storage = storage_
      
      // move self into a temporary working array
      var work = ArrayDeque()
      swap(&work, &self)
      
      // swap with the working array back before returning
      defer {
        swap(&work, &self)
      }
      return try storage.withUnsafeMutableBufferPointer(body)
  }
}

/// Returns `true` if these array deques contain the same elements.
@warn_unused_result
public func ==<Element : Equatable>(
  lhs: ArrayDeque<Element>, rhs: ArrayDeque<Element>
) -> Bool {
  return lhs.elementsEqual(rhs)
}

/// Returns `true` if these array deques do not contain the same elements.
@warn_unused_result
public func !=<Element : Equatable>(
  lhs: ArrayDeque<Element>, rhs: ArrayDeque<Element>
) -> Bool {
  return !lhs.elementsEqual(rhs)
}
