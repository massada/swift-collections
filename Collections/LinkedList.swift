//
//  LinkedList.swift
//  Collections
//
//  Created by José Massada on 25/01/2016.
//  Copyright © 2016 José Massada. All rights reserved.
//

class LinkedListBox<Element> {
  typealias Index = LinkedListIndex<Element>
  
  subscript(index: Index) -> Element {
    get {
      return index.node_.value_
    }
    set {
      index.node_.value_ = newValue
    }
  }
  
  func insert(newElement: Element, atIndex index: Index) {
    let newNode = LinkedListNode(value: newElement, next: index.node_,
      previous: index.node_.previous_)
    
    newNode.previous_.next_ = newNode
    newNode.next_.previous_ = newNode
    
    count_ += 1
  }
  
  @warn_unused_result
  func removeAtIndex(index: Index) -> Element {
    let node = index.node_
    let value = node.value_
    
    node.previous_.next_ = node.next_;
    node.next_.previous_ = node.previous_;
    
    count_ -= 1
    return value
  }
  
  var identity: UnsafePointer<Void> {
    return withUnsafePointer(&root_) {
      return UnsafePointer<Void>($0)
    }
  }
  
  var startIndex: Index {
    return LinkedListIndex<Element>(identity: identity, node: root_.next_)
  }
  
  var endIndex: Index {
    return LinkedListIndex<Element>(identity: identity, node: root_)
  }
  
  /// The root node.
  var root_ = LinkedListNode<Element>()
  
  /// The number of nodes.
  var count_: Int = 0
}

/// LinkedList
public struct LinkedList<Element> : ArrayLiteralConvertible {
  /// Constructs an empty `LinkedList`.
  public init() {
  }
  
  /// Constructs from an `Array` literal.
  public init(arrayLiteral elements: Element...) {
    self.init(elements)
  }
  
  /// Constructs from an arbitrary sequence with elements of type `Element`.
  public init<
    S : SequenceType where S.Generator.Element == Element
  >(_ sequence: S) {
    for element in sequence {
      append(element)
    }
  }
  
  /// The boxed reference to the dummy node.
  var box_ = LinkedListBox<Element>()
}

extension LinkedList : DequeCollectionType {
  public var count: Int {
    return box_.count_
  }
  
  public mutating func prepend(newElement: Element) {
    insert(newElement, atIndex: startIndex)
  }
  
  public mutating func append(newElement: Element) {
    insert(newElement, atIndex: endIndex)
  }
  
  @warn_unused_result
  public mutating func removeFirst() -> Element {
    return removeAtIndex(startIndex)
  }
  
  @warn_unused_result
  public mutating func removeLast() -> Element {
    return removeAtIndex(endIndex.predecessor())
  }
  
  public mutating func removeAll(keepCapacity keepCapacity: Bool = false) {
    box_ = LinkedListBox<Element>()
  }
}

extension LinkedList {
  func checkIndex(index: Index) {
    precondition(index.identity_ == box_.identity)
  }
  
  public mutating func insert(newElement: Element, atIndex index: Index) {
    checkIndex(index)
    
    if isUniquelyReferencedNonObjC(&box_) {
      box_.insert(newElement, atIndex: index)
    } else {
      let newBox = LinkedListBox<Element>()
      
      for i in startIndex..<index {
        newBox.insert(box_[i], atIndex: newBox.endIndex)
      }
      
      newBox.insert(newElement, atIndex: newBox.endIndex)
      
      for i in index..<endIndex {
        newBox.insert(box_[i], atIndex: newBox.endIndex)
      }
      
      box_ = newBox
    }
  }
  
  public mutating func removeAtIndex(index: Index) -> Element {
    checkIndex(index)
    
    let value: Element
    
    if isUniquelyReferencedNonObjC(&box_) {
      return box_.removeAtIndex(index)
    } else {
      let newBox = LinkedListBox<Element>()
      
      for i in startIndex..<index {
        newBox.insert(box_[i], atIndex: newBox.endIndex)
      }
      
      for i in index.successor()..<endIndex {
        newBox.insert(box_[i], atIndex: newBox.endIndex)
      }
      
      value = box_[index]
      box_ = newBox
    }
    return value
  }
}

extension LinkedList : Indexable, MutableIndexable {
  public typealias Index = LinkedListIndex<Element>
  
  public var startIndex: Index {
    return box_.startIndex
  }
  
  public var endIndex: Index {
    return box_.endIndex
  }
  
  public subscript(index: Index) -> Element {
    get {
      checkIndex(index)
      return box_[index]
    }
    set {
      checkIndex(index)
      
      if isUniquelyReferencedNonObjC(&box_) {
        box_[index] = newValue
      } else {
        let newBox = LinkedListBox<Element>()
        
        for i in startIndex..<index {
          newBox.insert(box_[i], atIndex: newBox.endIndex)
        }
        
        newBox.insert(newValue, atIndex: newBox.endIndex)
        
        for i in index..<endIndex {
          newBox.insert(box_[i], atIndex: newBox.endIndex)
        }
        
        box_ = newBox
      }
    }
  }
}

extension LinkedList : SequenceType {
  public typealias Generator = AnyGenerator<Element>
  
  public func generate() -> Generator {
    var index = startIndex
    return anyGenerator {
      let value = index.node_.value_
      index = index.successor()
      return value
    }
  }
}

extension LinkedList : CustomStringConvertible, CustomDebugStringConvertible {
  public var description: String {
    return Array(self).description
  }
  
  public var debugDescription: String {
    return "LinkedList(\(description))"
  }
}

@warn_unused_result
public func ==<Element : Equatable>(
  lhs: LinkedList<Element>, rhs: LinkedList<Element>
) -> Bool {
  return lhs.elementsEqual(rhs)
}

@warn_unused_result
public func !=<Element : Equatable>(
  lhs: LinkedList<Element>, rhs: LinkedList<Element>
) -> Bool {
  return !lhs.elementsEqual(rhs)
}
