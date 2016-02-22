//
//  Stack.swift
//  Collections
//
//  Created by José Massada on 24/01/2016.
//  Copyright © 2016 José Massada. All rights reserved.
//

// Stack
public struct Stack<Element> : ArrayLiteralConvertible {
  typealias Storage = CircularArray<Element>
  
  // Creates an empty Stack
  public init() {
    storage_ = Storage()
  }
  
  // Creates a Stack from an Array literal
  public init(arrayLiteral elements: Element...) {
    storage_ = Storage(minimumCapacity: elements.count)
    for element in elements {
      storage_.prepend(element)
    }
  }
  
  // Creates a Stack from a finite sequence of items
  public init<
    S : SequenceType where S.Generator.Element == Element
  >(_ sequence: S) {
    storage_ = Storage(minimumCapacity: sequence.underestimateCount())
    for element in sequence {
      storage_.prepend(element)
    }
  }
  
  // The elements storage
  var storage_: Storage
}

extension Stack : StackType {
  public var count: Int {
    return storage_.count
  }
  
  public mutating func clear() {
    storage_.removeAll()
  }
  
  public mutating func push(newElement: Element) {
    storage_.prepend(newElement)
  }
  
  @warn_unused_result
  public mutating func pop() -> Element {
    return storage_.removeFirst()
  }
  
  public var top: Element? {
    return storage_.first
  }
}

extension Stack : SequenceType {
  public typealias Generator = Storage.Generator
  
  @warn_unused_result
  public func generate() -> Generator {
    return storage_.generate()
  }
}

extension Stack : CustomStringConvertible, CustomDebugStringConvertible {
  public var description: String {
    return storage_.description
  }
  
  public var debugDescription: String {
    return "Stack(\(description))"
  }
}

@warn_unused_result
public func ==<Element : Equatable>(
  lhs: Stack<Element>, rhs: Stack<Element>
) -> Bool {
  return lhs.storage_ == rhs.storage_
}

@warn_unused_result
public func !=<Element : Equatable>(
  lhs: Stack<Element>, rhs: Stack<Element>
) -> Bool {
  return lhs.storage_ != rhs.storage_
}
