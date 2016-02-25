//
//  PriorityQueue.swift
//  Collections
//
//  Created by José Massada on 25/02/2016.
//  Copyright © 2016 massada. All rights reserved.
//

/// A *collection* where `Element`s are kept in order of priority.
public struct PriorityQueue<Element : Comparable> : ArrayLiteralConvertible {
  typealias Heap = CircularArray<Element>
  
  /// Constructs an empty `PriorityQueue` with descending order by default.
  public init(ascending: Bool = false) {
    heap_ = Heap()
    operation_ = ascending ? { $0 > $1 } : { $0 < $1 }
  }
  
  /// Constructs from an `Array` literal.
  public init(arrayLiteral elements: Element...) {
    heap_ = Heap(minimumCapacity: elements.count)
    operation_ = { $0 < $1 }
    
    for element in elements {
      enqueue(element)
    }
  }
  
  /// Constructs from an arbitrary sequence with elements of type `Element`.
  public init<
    S : SequenceType where S.Generator.Element == Element
    >(_ sequence: S) {
      heap_ = Heap(minimumCapacity: sequence.underestimateCount())
      operation_ = { $0 < $1 }
      
      for element in sequence {
        enqueue(element)
      }
  }
  
  /// The elements heap.
  var heap_: Heap
  
  /// The priority order operation.
  let operation_: (Element, Element) -> Bool
}

extension PriorityQueue : PriorityQueueType {
  /// Returns the number of elements.
  public var count: Int {
    return heap_.count
  }
  
  /// Clears `self`, removing all elements.
  public mutating func clear() {
    heap_.removeAll()
  }
  
  /// Enqueues `newElement` to `self` while keeping priority order.
  ///
  /// - Complexity: O(log n).
  public mutating func enqueue(newElement: Element) {
    heap_.append(newElement)
    heapifyUp(heap_.endIndex - 1)
  }
  
  /// Dequeues the highest/lowest priority element of `self` and returns it.
  ///
  /// - Complexity: O(log n).
  /// - Requires: `self.count > 0`.
  @warn_unused_result
  public mutating func dequeue() -> Element {
    precondition(count > 0)
    
    swap(&heap_[0], &heap_[heap_.endIndex - 1])
    
    let element = heap_.removeLast()
    heapifyDown(0)
    return element
  }
  
  /// Returns the highest/lowest priority element of `self`, or `nil` if
  /// `self` is empty.
  public var front: Element? {
    return heap_.first
  }
  
  /// Heapifies-up the heap.
  mutating func heapifyUp(index: Int) {
    let element = heap_[index]
    
    var i = index
    while i > 1 && operation_(heap_[i / 2], heap_[i]) {
      heap_[i / 2] = heap_[i]
      i = i / 2
    }
    
    heap_[i] = element
  }
  
  /// Heapifies-down the heap.
  mutating func heapifyDown(index: Int) {
    let element = heap_[index]
    
    var i = 2 * index + 1
    while i < heap_.count {
      var j = 2 * i + 1
      if j != heap_.count && operation_(heap_[j], heap_[j + 1]) {
        j += 1
      }
      
      if !operation_(element, heap_[j]) {
        break
      }
      
      heap_[i] = heap_[j]
      i = j
    }
    
    heap_[i] = element
  }
}

extension PriorityQueue : SequenceType {
  /// A type that provides the `PriorityQueue`'s iteration interface and
  /// encapsulates its iteration state.
  public typealias Generator = Heap.Generator
  
  /// Return a *generator* over the elements of the `PriorityQueue`.
  ///
  /// - Complexity: O(1).
  @warn_unused_result
  public func generate() -> Generator {
    return heap_.generate()
  }
}

extension PriorityQueue : CustomStringConvertible, CustomDebugStringConvertible {
  /// A textual representation of `self`.
  public var description: String {
    return heap_.description
  }
  
  /// A textual representation of `self`, suitable for debugging.
  public var debugDescription: String {
    return "PriorityQueue(\(description))"
  }
}

/// Returns `true` if these priority queues contain the same elements.
@warn_unused_result
public func ==<Element>(
  lhs: PriorityQueue<Element>, rhs: PriorityQueue<Element>
  ) -> Bool {
    return lhs.heap_ == rhs.heap_
}

/// Returns `true` if these priority queues do not contain the same elements.
@warn_unused_result
public func !=<Element>(
  lhs: PriorityQueue<Element>, rhs: PriorityQueue<Element>
) -> Bool {
  return lhs.heap_ != rhs.heap_
}
