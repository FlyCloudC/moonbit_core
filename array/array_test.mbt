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
test "to_string" {
  let empty : Array[Int] = []
  inspect(empty, content="[]")
  let a0 = [0]
  inspect(a0, content="[0]")
  a0.push(1)
  inspect(a0, content="[0, 1]")
  a0.push(2)
  inspect(a0, content="[0, 1, 2]")
}

///|
test "get" {
  let v = [3]
  inspect(v.get(-1), content="None")
  inspect(v.get(0), content="Some(3)")
  inspect(v.get(1), content="None")
}

///|
test "op_add" {
  inspect(([] : Array[Int]) + [], content="[]")
  inspect(([] : Array[Int]) + [1, 2, 3, 4, 5], content="[1, 2, 3, 4, 5]")
  inspect([1, 2, 3, 4, 5] + [], content="[1, 2, 3, 4, 5]")
  inspect(
    [1, 2, 3, 4, 5] + [6, 7, 8, 9, 10],
    content="[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]",
  )
}

///|
test "op_equal" {
  let v1 = [3, 4, 5]
  let v2 = [3, 4, 5]
  let v3 = [3, 4, 6]
  assert_true(v1 == v2)
  assert_false(v1 == v3)
}

///|
test "pop" {
  let v = []
  v.push(3)
  v.push(4)
  assert_eq(v.length(), 2)
  assert_eq(v.pop(), Some(4))
  assert_eq(v.pop(), Some(3))
  assert_eq(v.length(), 0)
  assert_eq(v.pop(), None)
}

///|
test "unsafe_pop" {
  let v = []
  v.push(3)
  v.push(4)
  assert_eq(v.length(), 2)
  assert_eq(v.unsafe_pop(), 4)
  assert_eq(v.unsafe_pop(), 3)
  assert_eq(v.length(), 0)
}

///|
test "push" {
  let v = [3, 4, 5]
  assert_eq(v, [3, 4, 5])
  v[0] = 6
  assert_eq(v, [6, 4, 5])
}

///|
test "push_iter" {
  let u = [1, 2, 3]
  let v = [4, 5, 6]
  u.push_iter(v.iter())
  inspect(u, content="[1, 2, 3, 4, 5, 6]")
}

///|
test "drain" {
  let v = [3, 4, 5]
  let v2 = [1, 2, 3, 4, 5]
  let vv = v.drain(1, 2)
  let v2v = v2.drain(2, 5)
  assert_eq(v, [3, 5])
  assert_eq(vv, [4])
  assert_eq(v2, [1, 2])
  assert_eq(v2v, [3, 4, 5])
}

///|
test "append" {
  let v1 = [3, 4, 5]
  let v2 = [6, 7, 8]
  v1.append(v2)
  assert_eq(v1, [3, 4, 5, 6, 7, 8])
  assert_eq(v1.length(), 6)
}

///|
test "each" {
  let v = [3, 4, 5]
  let mut sum = 0
  for x in v {
    sum = sum + x
  }
  assert_eq(sum, 12)
}

///|
test "each_rev" {
  let v = Array::new(capacity=3)
  v.push(3)
  v.push(4)
  v.push(5)
  let mut sum = 0
  v.rev_each(x => sum = sum + x)
  assert_eq(sum, 12)
}

///|
test "eachi" {
  let v = [3, 4, 5]
  let mut sum = 0
  for i, x in v {
    // todo: maybe support (i,x)
    sum = sum + x + i
  }
  assert_eq(sum, 15)
}

///|
test "rev_eachi" {
  let v = [3, 4, 5]
  let mut sum = 0
  v.rev_eachi((i, x) => sum = sum + x + i)
  assert_eq(sum, 15)
}

///|
test "clear" {
  let v = [3, 4, 5]
  v.clear()
  assert_eq(v.length(), 0)
}

///|
test "map" {
  let v = [3, 4, 5]
  let e : Array[Int] = []
  inspect(v.map(x => x + 1), content="[4, 5, 6]")
  inspect(
    v.map(_.to_string()),
    content=
      #|["3", "4", "5"]
    ,
  )
  inspect(e.map(x => x + 1), content="[]")
  // Is it correct?
  inspect(
    ["a", "b", "c"],
    content=
      #|["a", "b", "c"]
    ,
  )
}

///|
test "map_inplace" {
  let v = [3, 4, 5]
  let e : Array[Int] = []
  v.map_inplace(x => x + 1)
  e.map_inplace(x => x + 1)
  inspect(v, content="[4, 5, 6]")
  inspect(e, content="[]")
}

///|
test "mapi" {
  let v = [3, 4, 5]
  let e : Array[Int] = []
  inspect(v.mapi((i, x) => x + i), content="[3, 5, 7]")
  inspect(
    v.mapi((i, x) => (x + i).to_string()),
    content=
      #|["3", "5", "7"]
    ,
  )
  inspect(e.mapi((_i, x) => x + 1), content="[]")
}

///|
test "mapi_inplace" {
  let v = [3, 4, 5]
  let e : Array[Int] = []
  v.mapi_inplace((i, x) => x + i)
  e.mapi_inplace((_i, x) => x + 1)
  inspect(v, content="[3, 5, 7]")
  inspect(e, content="[]")
}

///|
test "filter" {
  let arr = [1, 2, 3, 4, 5, 6]
  inspect(arr.filter(x => x % 2 == 0), content="[2, 4, 6]")
}

///|
test "is_empty" {
  let v = []
  assert_true(v.is_empty())
  v.push(3)
  assert_false(v.is_empty())
}

///|
test "is_sorted" {
  let v : Array[Int] = []
  assert_true(v.is_sorted())
  let v = [3, 4, 5]
  assert_true(v.is_sorted())
  let v2 = [3, 5, 4]
  assert_false(v2.is_sorted())
}

///|
test "rev_inplace" {
  let v = [3, 4, 5]
  v.rev_inplace()
  assert_eq(v, [5, 4, 3])
  v.rev_inplace()
  assert_eq(v, [3, 4, 5])
  let v = [3, 4]
  v.rev_inplace()
  assert_eq(v, [4, 3])
  v.rev_inplace()
  assert_eq(v, [3, 4])
  let empty : Array[Int] = []
  assert_eq(empty, empty)
}

///|
test "rev" {
  let v = [3, 4, 5]
  let vv = v.rev()
  assert_eq(v, [3, 4, 5])
  assert_eq(vv, [5, 4, 3])
  let vv2 = vv.rev()
  assert_eq(vv2, [3, 4, 5])
}

///|
test "split_at" {
  let v = [3, 4, 5]
  let (v1, v2) = v.split_at(1)
  assert_eq(v1, [3])
  assert_eq(v2, [4, 5])
  let (v1, v2) = v.split_at(0)
  assert_eq(v1, [])
  assert_eq(v2, [3, 4, 5])
  let (v1, v2) = v.split_at(3)
  assert_eq(v1, [3, 4, 5])
  assert_eq(v2, [])
}

///|
test "contains" {
  let v = [3, 4, 5]
  assert_true(v.contains(3))
  assert_true(v.contains(4))
  assert_true(v.contains(5))
  assert_false(v.contains(6))
}

///|
test "starts_with" {
  let v = [3, 4, 5]
  assert_true(v.starts_with([3, 4]))
  assert_true(v.starts_with([3, 4, 5]))
  assert_false(v.starts_with([3, 4, 6]))
  assert_false(v.starts_with([3, 4, 5, 6]))
}

///|
test "ends_with" {
  let v = [3, 4, 5]
  assert_true(v.ends_with([4, 5]))
  assert_true(v.ends_with([3, 4, 5]))
  assert_false(v.ends_with([3, 4, 6]))
  assert_false(v.ends_with([2, 3, 4, 5]))
}

///|
test "strip_prefix" {
  let v = [3, 4, 5]
  let sv = v.strip_prefix([3])
  assert_eq(v, [3, 4, 5])
  assert_eq(sv, Some([4, 5]))
  assert_eq(v.strip_prefix([4]), None)
}

///|
test "strip_suffix" {
  let v = [3, 4, 5]
  let sv = v.strip_suffix([5])
  assert_eq(v, [3, 4, 5])
  assert_eq(sv, Some([3, 4]))
  assert_eq(v.strip_suffix([4]), None)
}

///|
test "search" {
  let v = [3, 4, 5]
  assert_eq(v.search(3), Some(0))
  assert_eq(v.search(4), Some(1))
  assert_eq(v.search(5), Some(2))
  assert_eq(v.search(6), None)
}

///|
test "swap" {
  let v = [3, 4, 5]
  v.swap(0, 2)
  assert_eq(v, [5, 4, 3])
  v.swap(0, 2)
  assert_eq(v, [3, 4, 5])
}

///|
test "remove" {
  let v = [3, 4, 5]
  assert_eq(v.remove(1), 4)
  assert_eq(v, [3, 5])
}

///|
test "retain" {
  let v = [3, 4, 5]
  v.retain(x => x > 3)
  assert_eq(v, [4, 5])
}

///|
test "resize" {
  let v = [3, 4, 5]
  v.resize(5, 0)
  assert_eq(v, [3, 4, 5, 0, 0])
  assert_eq(v.length(), 5)
  let vv = [3, 4, 5]
  vv.resize(2, 0)
  assert_eq(vv, [3, 4])
  assert_eq(vv.length(), 2)
}

///|
test "insert" {
  let v = [3, 4, 5]
  v.insert(1, 6)
  assert_eq(v, [3, 6, 4, 5])
  assert_eq(v.length(), 4)
}

///|
test "flatten" {
  let v = [[3, 4], [5, 6]]
  let vv = v.flatten()
  assert_eq(vv, [3, 4, 5, 6])
  assert_eq(vv.length(), 4)
}

///|
test "repeat" {
  let v = [3, 4]
  let vv = v.repeat(2)
  assert_eq(vv, [3, 4, 3, 4])
  assert_eq(vv.length(), 4)
}

///|
test "flatten" {
  let v = [[3, 4], [5, 6]]
  let vv = v.flatten()
  assert_eq(vv, [3, 4, 5, 6])
  assert_eq(vv.length(), 4)
}

///|
test "fold" {
  let sum = [1, 2, 3, 4, 5].fold(init=0, (sum, elem) => sum + elem)
  assert_eq(sum, 15)
}

///|
test "rev_fold" {
  let sum = [1, 2, 3, 4, 5].rev_fold(init=0, (sum, elem) => sum + elem)
  assert_eq(sum, 15)
  let op = (sum, elem) => sum - elem
  let data = [1, 2, 3, 4, 5]
  let ss0 = data.rev_fold(init=0, op)
  let ss1 = data.rev().fold(init=0, op)
  assert_eq(ss0, ss1)
}

///|
test "foldi" {
  let sum = [1, 2, 3, 4, 5].foldi(init=0, (index, sum, _elem) => sum + index)
  assert_eq(sum, 10)
}

///|
test "rev_foldi" {
  let sum = [1, 2, 3, 4, 5].rev_foldi(init=0, (index, sum, _elem) => sum + index)
  assert_eq(sum, 10)
  let op = (index, sum, elem) => index - sum - elem
  let data = [1, 2, 3, 4, 5, 10]
  let v0 = data.rev_foldi(init=0, op)
  let v1 = data.rev().foldi(init=0, op)
  assert_eq(v0, v1)
}

///|
test "dedup" {
  let v = [3, 4, 4, 5, 5, 5]
  v.dedup()
  assert_eq(v, [3, 4, 5])
  assert_eq(v.length(), 3)
}

///|
test "extract_if" {
  let v = [3, 4, 5]
  let vv = v.extract_if(x => x > 3)
  assert_eq(v, [3])
  assert_eq(v.length(), 1)
  assert_eq(vv, [4, 5])
}

///|
test "chunks" {
  let v = [1, 2, 3, 4, 5, 6, 7, 8, 9]
  let chunks = v.chunks(3)
  let chunks2 = v.chunks(2)
  assert_eq(chunks, [[1, 2, 3], [4, 5, 6], [7, 8, 9]])
  assert_eq(chunks2, [[1, 2], [3, 4], [5, 6], [7, 8], [9]])
}

///|
test "chunk_by" {
  let v = [1, 1, 2, 3, 2, 3, 2, 3, 4]
  let chunks = v.chunk_by((x, y) => x <= y)
  assert_eq(chunks[0], [1, 1, 2, 3])
  assert_eq(chunks[1], [2, 3])
  assert_eq(chunks[2], [2, 3, 4])
}

///|
test "split" {
  let v = [1, 0, 2, 0, 3, 0, 4]
  let chunks = v.split(x => x == 0)
  assert_eq(chunks, [[1], [2], [3], [4]])
  assert_eq(chunks.length(), 4)
}

///|
test "reserve_capacity" {
  let v = [1]
  // Only test that it doesn't panic
  v.reserve_capacity(10)
}

///|
test "reserve_capacity_2" {
  let v = [1, 2, 3, 4, 5]
  // Only test that it doesn't panic
  v.reserve_capacity(3)
}

///|
test "shrink_to_fit" {
  let v = Array::new(capacity=10)
  v.push(1)
  v.push(2)
  v.push(3)
  // Only test that it doesn't panic
  v.shrink_to_fit()
}

///|
test "shrink_to_fit_2" {
  let v = [1, 2, 3]
  // Only test that it doesn't panic
  v.shrink_to_fit()
}

///|
test "iter" {
  let buf = StringBuilder::new(size_hint=5)
  [1, 2, 3, 4, 5].iter().each(x => buf.write_string(x.to_string()))
  inspect(buf, content="12345")
  buf.reset()
  [1, 2, 3, 4, 5].iter().take(2).each(x => buf.write_string(x.to_string()))
  inspect(buf, content="12")
}

///|
test "shuffle_in_place" {
  let arr : Array[Int] = [1, 2, 3, 4, 5, 6, 7]
  fn rand(upper : Int) -> Int {
    let rng = @random.Rand::new()
    rng.int() % upper
  }

  let shuffled = Array::shuffle(arr, rand~)
  Array::shuffle_in_place(arr, rand~)
  assert_eq(shuffled, arr)
  inspect(arr, content="[3, 2, 1, 5, 6, 7, 4]")
}

///|
test "search_by" {
  let arr : Array[Int] = [1, 2, 3, 4, 5, 6, 7]
  let index = arr.search_by(x => x == 3)
  assert_eq(index, Some(2))
}

///|
test "copy" {
  let arr = [1, 2, 3, 4, 5]
  let copied = arr.copy()
  assert_eq(copied, [1, 2, 3, 4, 5])
  @test.is_not(arr, copied)
  inspect(([] : Array[Int]).copy(), content="[]")
}

///|
test "Array::makei with positive length" {
  let arr = Array::makei(5, i => i * 2)
  assert_eq(arr, [0, 2, 4, 6, 8])
}

///|
test "Array::makei with zero length" {
  let arr = Array::makei(0, i => i * 2)
  assert_eq(arr, [])
}

///|
test "Array::makei with negative length" {
  let arr = Array::makei(-1, i => i * 2)
  assert_eq(arr, [])
}

///|
test "filter_map" {
  let arr = [1, 2, 3, 4, 5]
  let mapped = arr.filter_map(x => if x % 2 == 0 { Some(x) } else { None })
  inspect(mapped, content="[2, 4]")
}

///|
test "from_iter" {
  let arr : Array[Int] = []
  inspect(Array::from_iter(arr.iter()), content="[]")
  let arr = [1, 2, 3, 4, 5]
  inspect(Array::from_iter(arr.iter()), content="[1, 2, 3, 4, 5]")
}

///|
test "Array::iter2" {
  let arr = [1, 2, 3]
  let v = arr.iter2()
  let mut res = ""
  v.each((k, v) => res = res + k.to_string() + v.to_string())
  inspect(res, content="011223")
  res = ""
  arr.iter2().iter().each(x => res = res + x.to_string())
  inspect(res, content="(0, 1)(1, 2)(2, 3)")
}

///|
test "Array::last" {
  // Test with a random array of integers
  inspect([1, 2, 3, 4, 5].last(), content="Some(5)")

  // Test with a random array of strings
  inspect(["a", "b", "c"].last(), content="Some(\"c\")")

  // Test with a large array
  let large_array = Array::make(10, 0)
  inspect(large_array.last(), content="Some(0)")

  // Test with an empty array
  inspect(([] : Array[Unit]).last(), content="None")

  // Test with a single-element array
  inspect([1].last(), content="Some(1)")
}

///|
test "zip" {
  // Test with two non-empty arrays
  let arr1 = [1, 2, 3]
  let arr2 = ['a', 'b', 'c']
  inspect(arr1.zip(arr2), content="[(1, 'a'), (2, 'b'), (3, 'c')]")

  // Test with arrays of different lengths
  let arr3 = [1, 2]
  let arr4 = ["a", "b", "c"]
  inspect(
    arr3.zip(arr4),
    content=
      #|[(1, "a"), (2, "b")]
    ,
  )

  // Test with an empty array
  let arr5 : Array[Int] = []
  let arr6 = ["a", "b", "c"]
  inspect(arr5.zip(arr6), content="[]")
}

///|
test "unzip" {
  // Test with a non-empty array of tuples
  let arr = [(1, "a"), (2, "b"), (3, "c")]
  let (nums, strs) = arr.unzip()
  assert_eq(nums, [1, 2, 3])
  assert_eq(strs, ["a", "b", "c"])

  // Test with an empty array
  let empty : Array[(Int, String)] = []
  let (e1, e2) = empty.unzip()
  assert_eq(e1, [])
  assert_eq(e2, [])
}

///|
test "zip_with" {
  // Test with two non-empty arrays and a function
  let arr1 = [1, 2, 3]
  let arr2 = [4, 5, 6]
  let add = (a, b) => a + b
  inspect(zip_with(arr1, arr2, add), content="[5, 7, 9]")

  // Test with arrays of different lengths and a function
  let arr3 = [1, 2]
  let arr4 = [4, 5, 6]
  inspect(zip_with(arr3, arr4, add), content="[5, 7]")

  // Test with an empty array and a function
  let arr5 : Array[Int] = []
  let arr6 = [4, 5, 6]
  inspect(zip_with(arr5, arr6, add), content="[]")
}

///|
test "zip_to_iter2" {
  // Test with two non-empty arrays
  let arr1 = [1, 2, 3]
  let arr2 = ['a', 'b', 'c']
  inspect(
    arr1.zip_to_iter2(arr2).to_array(),
    content="[(1, 'a'), (2, 'b'), (3, 'c')]",
  )

  // Test with arrays of different lengths
  let arr3 = [1, 2]
  let arr4 = ["a", "b", "c"]
  inspect(
    arr3.zip_to_iter2(arr4).to_array(),
    content=
      #|[(1, "a"), (2, "b")]
    ,
  )

  // Test with an empty array
  let arr5 : Array[Int] = []
  let arr6 = ["a", "b", "c"]
  inspect(arr5.zip_to_iter2(arr6), content="[]")
}

///|
test "zip_to_iter2 current behavior" {
  // Only for recording what can be done, but not what should be done
  let arr = [1, 2, 3]
  let arr2 = ['a', 'b', 'c']
  let iter = arr.zip_to_iter2(arr2)
  arr.push(4)
  arr2.push('d')
  inspect(iter.to_array(), content="[(1, 'a'), (2, 'b'), (3, 'c'), (4, 'd')]")
  arr.clear()
  inspect(iter.to_array(), content="[]")
}

///|
test "arbitrary" {
  let arr : Array[Array[Int]] = @quickcheck.samples(20)
  inspect(arr[5:9], content="[[], [], [0], [0, 0]]")
  inspect(
    arr[10:15],
    content="[[0, 0, 1, 0, -2], [0, 0, 0, -1, -2], [0, 0, 0, 0, 0, -2, -5, 4, 0, 8], [0, 0, -1, 2], [0, 0]]",
  )
}

///|
test "Array[String]::join" {
  let arr = ["a", "b", "c"]
  inspect(arr.join(","), content="a,b,c")
  inspect(["a", "b", "c"].join(","), content="a,b,c")
  inspect(["a", "b", "c"].join(""), content="abc")
  inspect(["a", "b", "c"].join(" "), content="a b c")
  inspect(["123", "456"].join(""), content="123456")
  inspect(["aaa", "bbb", "ccc"].join(" "), content="aaa bbb ccc")
  inspect([].join(" "))
}

///|
test "Array[View]::join" {
  let arr = ["a", "b", "c"][:]
  inspect(arr.join(","), content="a,b,c")
  inspect(["a", "b", "c"][:].join(","), content="a,b,c")
  inspect(["a", "b", "c"][:].join(""), content="abc")
  inspect(["a", "b", "c"][:].join(" "), content="a b c")
  inspect(["123", "456"][:].join(""), content="123456")
  inspect(["aaa", "bbb", "ccc"][:].join(" "), content="aaa bbb ccc")
  inspect([][:].join(" "))
}

///|
test "Array::pop_back" {
  let arr = [1]
  arr.unsafe_pop_back()
  assert_eq(arr, [])
}
