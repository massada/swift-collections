//
//  LinkedListIndex.swift
//  Collections
//
//  Created by José Massada on 28/01/2016.
//  Copyright © 2016 José Massada. All rights reserved.
//


/// A `LinkedList` index.
public struct LinkedListIndex<Element> : BidirectionalIndexType {
  /// The owning identity.
  let identity_: UnsafePointer<Void>
  
  /// The linked list node.
  let node_: LinkedListNode<Element>
  
  public func predecessor() -> LinkedListIndex {
    return LinkedListIndex(identity: identity_, node: node_.previous_)
  }
  
  public func successor() -> LinkedListIndex {
    return LinkedListIndex(identity: identity_, node: node_.next_)
  }
  
  init(identity: UnsafePointer<Void>, node: LinkedListNode<Element>) {
    identity_ = identity
    node_ = node
  }
}

public func ==<Element>(
  lhs: LinkedListIndex<Element>, rhs: LinkedListIndex<Element>
) -> Bool {
  return lhs.node_ === rhs.node_
}
