//
//  LinkedListNode.swift
//  Collections
//
//  Created by José Massada on 28/01/2016.
//  Copyright © 2016 José Massada. All rights reserved.
//

/// A `LinkedList` node.
class LinkedListNode<Element> {
  /// Constructs a `LinkedListNode` that points to itself.
  init() {
    next_ = self
    previous_ = self
  }
  
  /// Constructs a `LinkedListNode`.
  init(value: Element?, next: LinkedListNode?, previous: LinkedListNode?) {
    value_ = value
    next_ = next
    previous_ = previous
  }
  
  /// The value.
  var value_: Element!
  
  /// The next node.
  var next_: LinkedListNode!
  
  /// The previous node.
  var previous_: LinkedListNode!
}
