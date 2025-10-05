// Copyright 2025 International Digital Economy Academy
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

///|
const SIGN_MASK : UInt = 0x8000_0000

///|
const EXP_BIAS = 127

///|
const EXP_BITS = 8

///|
const FRAC_BITS = 23

///|
/// Returns the truncated value of a floating-point number by removing its
/// fractional part.
///
/// Parameters:
///
/// * `value` : The floating-point number to be truncated.
///
/// Returns the truncated floating-point number. Specifically:
///
/// * Returns `0.0` (with the same sign as input) for values between -1.0 and 1.0
/// * Returns the input unchanged for integer values or values too large to have
/// fractional parts
/// * Returns the integer part for other values
///
/// Example:
///
/// ```moonbit
///   inspect((3.7 : Float).trunc(), content="3")
///   inspect((-3.7 : Float).trunc(), content="-3")
///   inspect((0.2 : Float).trunc(), content="0")
/// ```
#as_free_fn
pub fn Float::trunc(self : Float) -> Float {
  let u32 = self.reinterpret_as_uint()
  let biased_exp = ((u32 >> FRAC_BITS) & ((0x1U << EXP_BITS) - 1)).reinterpret_as_int()
  if biased_exp < EXP_BIAS {
    return (u32 & SIGN_MASK).reinterpret_as_float()
  } else if biased_exp >= EXP_BIAS + FRAC_BITS {
    return self
  }
  let mask_shift = biased_exp - EXP_BIAS + EXP_BITS
  let trunc_mask = (SIGN_MASK.reinterpret_as_int() >> mask_shift).reinterpret_as_uint()
  return (u32 & trunc_mask).reinterpret_as_float()
}

///|
/// Returns the smallest integer greater than or equal to a given floating-point
/// number.
///
/// Parameters:
///
/// * `value` : The floating-point number to be rounded up.
///
/// Returns a floating-point number representing the ceiling value.
///
/// Example:
///
/// ```moonbit
///   inspect((1.5 : Float).ceil(), content="2")
///   inspect((1.0 : Float).ceil(), content="1")
///   inspect((-1.5 : Float).ceil(), content="-1")
/// ```
#as_free_fn
pub fn Float::ceil(self : Float) -> Float {
  let trunced = self.trunc()
  if self > trunced {
    return trunced + 1.0
  } else {
    return trunced
  }
}

///|
/// Returns the largest integer value less than or equal to the given
/// floating-point number.
///
/// Parameters:
///
/// * `self` : The floating-point number to be floored.
///
/// Returns a floating-point number representing the largest integer less than or
/// equal to the input.
///
/// Example:
///
/// ```moonbit
///   inspect((1.7 : Float).floor(), content="1")
///   inspect((-1.7 : Float).floor(), content="-2")
///   inspect((2.0 : Float).floor(), content="2")
/// ```
#as_free_fn
pub fn Float::floor(self : Float) -> Float {
  let trunced = self.trunc()
  if self < trunced {
    return trunced - 1.0
  } else {
    return trunced
  }
}

///|
/// Rounds a floating-point number to the nearest integer value, with ties
/// rounding up (towards positive infinity).
///
/// Parameters:
///
/// * `number` : The floating-point number to be rounded.
///
/// Returns a floating-point number representing the rounded value.
///
/// Example:
///
/// ```moonbit
///   inspect((2.3 : Float).round(), content="2")
///   inspect((2.5 : Float).round(), content="3")
///   inspect((-2.5 : Float).round(), content="-2")
/// ```
#as_free_fn
pub fn Float::round(self : Float) -> Float {
  floor(self + 0.5)
}
