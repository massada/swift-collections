//
// StackType.swift
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

/// A *collection* that supports adding an element and removing the most
/// recently added element.
public protocol StackType : Sequence, ExpressibleByArrayLiteral {
  /// Returns the number of elements.
  var count: Int { get }
  
  /// Returns `true` if `self` is empty.
  var isEmpty: Bool { get }
  
  /// Clears `self`, removing all elements.
  mutating func clear()
  
  /// Pushes `newElement` to `self`.
  mutating func push(_ newElement: Iterator.Element)
  
  /// Pops the most recently added element of `self` and returns it.
  mutating func pop() -> Iterator.Element
  
  /// Returns the most recently added element of `self`, or `nil` if `self` is
  /// empty.
  var top: Iterator.Element? { get }
}

// Default implementations
extension StackType {
  public var isEmpty: Bool {
    return count == 0
  }
}
