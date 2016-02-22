//
//  Queue.swift
//  Collections
//
//  Created by José Massada on 23/01/2016.
//  Copyright © 2016 José Massada. All rights reserved.
//

// Queue
public struct Queue<Element> : ArrayLiteralConvertible {
  typealias Storage = CircularArray<Element>
  
  // Create an empty queue
  public init() {
    storage_ = Storage()
  }
  
  // Create a Queue from an Array literal
  public init(arrayLiteral elements: Element...) {
    storage_ = Storage(elements)
  }
  
  // Create a Queue from a finite sequence of items
  public init<
    S : SequenceType where S.Generator.Element == Element
  >(_ sequence: S) {
    storage_ = Storage(sequence)
  }
  
  // The elements storage
  var storage_: Storage
}

extension Queue : QueueType {
  public var count: Int {
    return storage_.count
  }
  
  public mutating func clear() {
    storage_.removeAll()
  }
  
  public mutating func enqueue(newElement: Element) {
    storage_.append(newElement)
  }
  
  @warn_unused_result
  public mutating func dequeue() -> Element {
    return storage_.removeFirst()
  }
  
  public var front: Element? {
    return storage_.first
  }
}

extension Queue : SequenceType {
  public typealias Generator = Storage.Generator
  
  @warn_unused_result
  public func generate() -> Generator {
    return storage_.generate()
  }
}

extension Queue : CustomStringConvertible, CustomDebugStringConvertible {
  public var description: String {
    return storage_.description
  }
  
  public var debugDescription: String {
    return "Queue(\(description))"
  }
}

@warn_unused_result
public func ==<Element : Equatable>(
  lhs: Queue<Element>, rhs: Queue<Element>
) -> Bool {
    return lhs.storage_ == rhs.storage_
}

@warn_unused_result
public func !=<Element : Equatable>(
  lhs: Queue<Element>, rhs: Queue<Element>
) -> Bool {
  return lhs.storage_ != rhs.storage_
}
