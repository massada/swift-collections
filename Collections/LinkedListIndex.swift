//
// LinkedListIndex.swift
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

/// A `LinkedList` index.
public struct LinkedListIndex<Element> : Comparable {
  /// The owning identity.
  let identity: UnsafeRawPointer
  
  /// The linked list node.
  let node: LinkedListNode<Element>
  
  /// The linked list node offset.
  let offset: Int
  
  /// Constructs from `identity`, `node` and `offset`.
  init(identity: UnsafeRawPointer, node: LinkedListNode<Element>, offset: Int) {
    self.identity = identity
    self.node = node
    self.offset = offset
  }
}

/// Returns `true` if these linked list indices are equal.
public func ==<Element>(
  lhs: LinkedListIndex<Element>, rhs: LinkedListIndex<Element>
) -> Bool {
  return lhs.node === rhs.node
}

/// Returns `true` if the first linked list index argument is less than the
/// second.
public func <<Element>(
  lhs: LinkedListIndex<Element>, rhs: LinkedListIndex<Element>
) -> Bool {
  return lhs.offset < rhs.offset
}
