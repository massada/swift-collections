//
//  QueueType.swift
//  Collections
//
//  Created by José Massada on 26/01/2016.
//  Copyright © 2016 José Massada. All rights reserved.
//

// Queue
public protocol QueueType : ArrayLiteralConvertible, SequenceType {
  typealias Element
  
  var count: Int { get }
  
  var isEmpty: Bool { get }
  
  mutating func clear()
  
  mutating func enqueue(newElement: Element)
  
  @warn_unused_result
  mutating func dequeue() -> Element
  
  var front: Element? { get }
}

// Default implementations
extension QueueType {
  public var isEmpty: Bool {
    return count == 0
  }
}
