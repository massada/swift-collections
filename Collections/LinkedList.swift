//
// LinkedList.swift
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

/// A doubly linked list of `Element`.
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
  
  /// The boxed dummy node reference.
  var box_ = LinkedListBox<Element>()
}

extension LinkedList : DequeCollectionType {
  /// Returns the number of elements.
  ///
  /// - Complexity: O(1).
  public var count: Int {
    return box_.count_
  }
  
  /// Prepends `newElement` to the `LinkedList`.
  ///
  /// Invalidates all indices with respect to `self`.
  ///
  /// - Complexity: O(1).
  public mutating func prepend(newElement: Element) {
    insert(newElement, atIndex: startIndex)
  }
  
  /// Appends `newElement` to the `LinkedList`.
  ///
  /// Applying `successor()` to the index of the new element yields
  /// `self.endIndex`.
  ///
  /// - Complexity: O(1).
  public mutating func append(newElement: Element) {
    insert(newElement, atIndex: endIndex)
  }
  
  /// Inserts `newElement` at `index`.
  ///
  /// - Complexity: O(1).
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
  
  /// Removes the element at `startIndex` and returns it.
  ///
  /// - Complexity: O(1).
  /// - Requires: `self.count > 0`.
  @warn_unused_result
  public mutating func removeFirst() -> Element {
    return removeAtIndex(startIndex)
  }
  
  /// Removes the element at the end and returns it.
  ///
  /// - Complexity: O(1).
  /// - Requires: `count > 0`
  @warn_unused_result
  public mutating func removeLast() -> Element {
    return removeAtIndex(endIndex.predecessor())
  }
  
  /// Removes the element at `index` and returns it.
  ///
  /// - Complexity: O(1).
  /// - Requires: `count > 0`
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
    box_ = LinkedListBox<Element>()
  }
}

extension LinkedList : Indexable, MutableIndexable {
  /// A type that represents a valid position in the collection.
  ///
  /// Valid indices consist of the position of every element and a
  /// "past the end" position that's not valid for use as a subscript.
  public typealias Index = LinkedListIndex<Element>
  
  /// The position of the first element in a non-empty collection.
  ///
  /// In an empty collection, `startIndex == endIndex`.
  public var startIndex: Index {
    return box_.startIndex
  }
  
  /// A "past-the-end" element index; the successor of the last valid
  /// subscript argument.
  public var endIndex: Index {
    return box_.endIndex
  }
  
  /// Access the `index`th element.
  ///
  /// - Complexity: O(1).
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
  
  /// Checks that the given `index` is valid.
  func checkIndex(index: Index) {
    precondition(index.identity_ == box_.identity)
  }
}

extension LinkedList : SequenceType {
  /// A type that provides the `LinkedList`'s iteration interface and
  /// encapsulates its iteration state.
  public typealias Generator = AnyGenerator<Element>
  
  /// Return a *generator* over the elements of the `LinkedList`.
  ///
  /// - Complexity: O(1).
  public func generate() -> Generator {
    var index = startIndex
    return AnyGenerator {
      let value = index.node_.value_
      index = index.successor()
      return value
    }
  }
}

extension LinkedList : CustomStringConvertible, CustomDebugStringConvertible {
  /// A textual representation of `self`.
  public var description: String {
    return Array(self).description
  }
  
  /// A textual representation of `self`, suitable for debugging.
  public var debugDescription: String {
    return "LinkedList(\(description))"
  }
}

/// Returns `true` if these linked lists contain the same elements.
@warn_unused_result
public func ==<Element : Equatable>(
  lhs: LinkedList<Element>, rhs: LinkedList<Element>
) -> Bool {
  return lhs.elementsEqual(rhs)
}

/// Returns `true` if these linked lists do not contain the same elements.
@warn_unused_result
public func !=<Element : Equatable>(
  lhs: LinkedList<Element>, rhs: LinkedList<Element>
) -> Bool {
  return !lhs.elementsEqual(rhs)
}
