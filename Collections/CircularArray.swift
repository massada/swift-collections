//
//  CircularArray.swift
//  Collections
//
//  Created by José Massada on 24/01/2016.
//  Copyright © 2016 José Massada. All rights reserved.
//

/// A fast, double-ended queue of `Element`.
public struct CircularArray<Element> : ArrayLiteralConvertible {
  typealias Storage = CircularArrayBuffer<Element>
  
  /// Constructs an empty `CircularArray`.
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

extension CircularArray {
  public func withUnsafeBufferPointer<R>(
    @noescape body: (UnsafeBufferPointer<Element>) throws -> R
  ) rethrows -> R {
    return try storage_.withUnsafeBufferPointer(body)
  }
  
  public func withUnsafeMutableBufferPointer<R>(
    @noescape body: (UnsafeMutableBufferPointer<Element>) throws -> R
  ) rethrows -> R {
    return try storage_.withUnsafeMutableBufferPointer(body)
  }
  
  mutating func makeMutableAndUnique() {
    if !isUniquelyReferencedNonObjC(&storage_) {
      storage_ = CircularArrayBuffer(buffer: storage_)
    }
  }
}

extension CircularArray : DequeCollectionType {
  public mutating func reserveCapacity(minimumCapacity: Int) {
    makeMutableAndUnique()
    storage_.reserveCapacity(minimumCapacity)
  }
  
  public mutating func prepend(newElement: Element) {
    makeMutableAndUnique()
    storage_.prepend(newElement)
  }
  
  public mutating func prependContentsOf<
    S : SequenceType where S.Generator.Element == Element
  >(newElements: S) {
    reserveCapacity(newElements.underestimateCount())
    for element in newElements.reverse() {
      storage_.prepend(element)
    }
  }
  
  public mutating func prependContentsOf<
    C : CollectionType where C.Generator.Element == Element
  >(newElements: C) {
    reserveCapacity(numericCast(newElements.count))
    for element in newElements.reverse() {
      storage_.prepend(element)
    }
  }
  
  public mutating func append(newElement: Element) {
    makeMutableAndUnique()
    storage_.append(newElement)
  }
  
  public mutating func appendContentsOf<
    S : SequenceType where S.Generator.Element == Element
  >(newElements: S) {
    reserveCapacity(newElements.underestimateCount())
    for element in newElements {
      storage_.append(element)
    }
  }
  
  public mutating func appendContentsOf<
    C : CollectionType where C.Generator.Element == Element
  >(newElements: C) {
    reserveCapacity(numericCast(newElements.count))
    for element in newElements {
      storage_.append(element)
    }
  }
  
  @warn_unused_result
  public mutating func removeFirst() -> Element {
    makeMutableAndUnique()
    return storage_.removeFirst()
  }
  
  public mutating func removeFirst(count: Int) {
    makeMutableAndUnique()
    storage_.removeFirst(count)
  }
  
  @warn_unused_result
  public mutating func removeLast() -> Element {
    makeMutableAndUnique()
    return storage_.removeLast()
  }
  
  public mutating func removeLast(count: Int) {
    makeMutableAndUnique()
    storage_.removeLast(count)
  }
  
  public mutating func removeAll(keepCapacity keepCapacity: Bool = false) {
    if !isUniquelyReferencedNonObjC(&storage_) {
      let capacity = (keepCapacity) ? storage_.capacity : 0
      storage_ = Storage(minimumCapacity: capacity)
    } else {
      storage_.removeAll(keepCapacity: keepCapacity)
    }
  }
}

extension CircularArray : Indexable, MutableIndexable {
  public typealias Index = Int
  
  public var startIndex: Index {
    return 0
  }
  
  public var endIndex: Index {
    return storage_.count
  }
  
  public subscript(index: Index) -> Element {
    get {
      return storage_[index]
    } set {
      makeMutableAndUnique()
      storage_[index] = newValue
    }
  }
}

extension CircularArray : SequenceType {
  public typealias Generator = AnyGenerator<Element>
  
  public func generate() -> Generator {
    return anyGenerator(IndexingGenerator(self))
  }
}

extension CircularArray
  : CustomStringConvertible, CustomDebugStringConvertible {
  
  public var description: String {
    return Array(self).description
  }
  
  public var debugDescription: String {
    return "CircularArray(\(description))"
  }
}

@warn_unused_result
public func ==<Element : Equatable>(
  lhs: CircularArray<Element>, rhs: CircularArray<Element>
) -> Bool {
  return lhs.elementsEqual(rhs)
}

@warn_unused_result
public func !=<Element : Equatable>(
  lhs: CircularArray<Element>, rhs: CircularArray<Element>
) -> Bool {
  return !lhs.elementsEqual(rhs)
}
