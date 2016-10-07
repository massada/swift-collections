//
// Misc.swift
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

/// Returns `true` if `value` is a power of 2.
public func isPowerOfTwo<T : Integer>(_ value: T) -> Bool {
  return value > 0 && (value & (value &- 1)) == 0
}

/// Returns the `value`s nearest power of 2.
public func nearestPowerOfTwo<T : Integer>(_ value: T) -> T {
  var v: T = 1
  while (v < value) {
    v *= 2
  }
  return v
}
