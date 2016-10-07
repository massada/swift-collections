//
// LinkedListNode.swift
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
  
  /// Returns `true` if `self` is the root node.
  var isRoot: Bool {
    return next_ === self
  }
  
  /// The value.
  var value_: Element!
  
  /// The next node.
  var next_: LinkedListNode!
  
  /// The previous node.
  var previous_: LinkedListNode!
}
