//
//  DequeCollectionType.swift
//  Collections
//
//  Created by José Massada on 24/01/2016.
//  Copyright © 2016 José Massada. All rights reserved.
//

/// A *collection* that supports adding or removing elements from either the
/// front or back.
public protocol DequeCollectionType
  : MutableCollectionType, MutableSliceable, ArrayLiteralConvertible
{
  /// A type that represents a valid position in the collection.
  ///
  /// Valid indices consist of the position of every element and a
  /// "past the end" position that's not valid for use as a subscript.
  ///
  /// - Note: This associated type appears as a requirement in `Indexable`, but
  ///   is restated here with stricter constraints: in a `DequeCollectionType`,
  ///   the `Index` should also be a `BidirectionalIndexType`.
  typealias Index : BidirectionalIndexType
  
  /// A non-binding request to ensure `n` elements of available storage.
  ///
  /// This works as an optimization to avoid multiple reallocations of
  /// linear data structures like `CircularArray`.  Conforming types may
  /// reserve more than `n`, exactly `n`, less than `n` elements of
  /// storage, or even ignore the request completely.
  mutating func reserveCapacity(minimumCapacity: Int)
  
  /// Prepends `newElement` to `self`.
  ///
  /// Invalidates all indices with respect to `self`.
  mutating func prepend(newElement: Generator.Element)
  
  /// Prepends the elements of `newElements` to `self`.
  ///
  /// - Complexity: O(*length of `newElements`*).
  mutating func prependContentsOf<
    S : SequenceType where S.Generator.Element == Generator.Element
  >(newElements: S)
  
  /// Appends `newElement` to `self`.
  ///
  /// Applying `successor()` to the index of the new element yields
  /// `self.endIndex`.
  mutating func append(newElement: Generator.Element)
  
  /// Appends the elements of `newElements` to `self`.
  ///
  /// - Complexity: O(*length of `newElements`*).
  mutating func appendContentsOf<
    S : SequenceType where S.Generator.Element == Generator.Element
  >(newElements: S)
  
  /// Removes the element at `startIndex` and returns it.
  ///
  /// - Requires: `!self.isEmpty`.
  @warn_unused_result
  mutating func removeFirst() -> Generator.Element
  
  /// Removes the first `n` elements.
  ///
  /// - Complexity: O(`n`).
  /// - Requires: `self.count >= n`.
  mutating func removeFirst(n: Int)
  
  /// Removes the element at the end and returns it.
  ///
  /// - Requires: `!self.isEmpty`
  @warn_unused_result
  mutating func removeLast() -> Generator.Element
  
  /// Removes the last `n` elements.
  ///
  /// - Complexity: O(`n`).
  /// - Requires: `n >= 0 && self.count >= n`.
  mutating func removeLast(n: Int)
  
  /// Removes all elements.
  ///
  /// Invalidates all indices with respect to `self`.
  ///
  /// - Parameter keepCapacity: If `true`, is a non-binding request to
  ///   avoid releasing storage, which can be a useful optimization
  ///   when `self` is going to be grown again.
  ///
  /// - Complexity: O(`self.count`).
  mutating func removeAll(keepCapacity keepCapacity: Bool)
}

// Default implementations
extension DequeCollectionType {
  public mutating func reserveCapacity(minimumCapacity: Int) {
  }
  
  public mutating func prependContentsOf<
    S : SequenceType where S.Generator.Element == Generator.Element
  >(newElements: S) {
    for element in newElements.reverse() {
      prepend(element)
    }
  }
  
  public mutating func appendContentsOf<
    S : SequenceType where S.Generator.Element == Generator.Element
  >(newElements: S) {
    for element in newElements {
      append(element)
    }
  }
  
  public mutating func removeFirst(n: Int) {
    if n == 0 {
      return
    }
    
    precondition(n >= 0, "number of elements to remove should be non-negative")
    precondition(count >= numericCast(n),
      "can't remove more items from a collection than it contains")
    
    for _ in 0..<n {
      _ = removeFirst()
    }
  }
  
  public mutating func removeLast(n: Int) {
    if n == 0 {
      return
    }
    
    precondition(n >= 0, "number of elements to remove should be non-negative")
    precondition(count >= numericCast(n),
      "can't remove more items from a collection than it contains")
    
    for _ in 0..<n {
      _ = removeFirst()
    }
  }
  
  public mutating func removeAll(keepCapacity keepCapacity: Bool = false) {
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
  @warn_unused_result
  public mutating func removeFirst() -> Generator.Element {
    precondition(!isEmpty, "can't remove items from an empty collection")
    
    let element = first!
    self = self[startIndex.successor()..<endIndex]
    return element
  }
  
  /// Removes the first `n` elements.
  ///
  /// - Complexity: O(1).
  /// - Requires: `self.count >= n`.
  public mutating func removeFirst(n: Int) {
    if n == 0 {
      return
    }
    
    precondition(n >= 0, "number of elements to remove should be non-negative")
    precondition(count >= numericCast(n),
      "can't remove more items from a collection than it contains")
    
    self = self[startIndex.advancedBy(numericCast(n))..<endIndex]
  }
  
  /// Removes the element at the end and returns it.
  ///
  /// - Complexity: O(1).
  /// - Requires: `!self.isEmpty`.
  @warn_unused_result
  public mutating func removeLast() -> Generator.Element {
    precondition(!isEmpty, "can't remove items from an empty collection")
    
    let element = first!
    self = self[startIndex..<endIndex.predecessor()]
    return element
  }
  
  /// Removes the last `n` elements.
  ///
  /// - Complexity: O(1).
  /// - Requires: `n >= 0 && self.count >= n`.
  public mutating func removeLast(n: Int) {
    if n == 0 {
      return
    }
    
    precondition(n >= 0, "number of elements to remove should be non-negative")
    precondition(count >= numericCast(n),
      "can't remove more items from a collection than it contains")
    
    self = self[startIndex..<endIndex.advancedBy(-numericCast(n))]
  }
}
