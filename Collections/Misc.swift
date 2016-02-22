//
//  Misc.swift
//  Collections
//
//  Created by José Massada on 20/02/2016.
//  Copyright © 2016 José Massada. All rights reserved.
//

/// Returns `true` if `value` is a power of 2.
@warn_unused_result
public func isPowerOfTwo<T : IntegerType>(value: T) -> Bool {
  return value > 0 && (value & (value &- 1)) == 0
}

/// Returns the `value` nearest power of 2.
@warn_unused_result
public func nearestPowerOfTwo<T : IntegerType>(value: T) -> T {
  var v: T = 1
  while (v < value) {
    v *= 2
  }
  return v
}
