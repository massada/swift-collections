//
//  StackType.swift
//  Collections
//
//  Created by José Massada on 26/01/2016.
//  Copyright © 2016 José Massada. All rights reserved.
//

// StackType
public protocol StackType : ArrayLiteralConvertible, SequenceType {
  typealias Element
  
  var count: Int { get }
  
  var isEmpty: Bool { get }
  
  mutating func clear()
  
  mutating func push(newElement: Element)
  
  @warn_unused_result
  mutating func pop() -> Element
  
  var top: Element? { get }
}

// Default implementations
extension StackType {
  public var isEmpty: Bool {
    return count == 0
  }
}
