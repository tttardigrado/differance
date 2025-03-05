import differance
import gleeunit
import gleeunit/should
import gleam/option.{None, Some}
import gleam/string

pub fn main() {
  gleeunit.main()
}

// Test empty 
pub fn empty_test() {
  differance.empty()
  |> differance.to_list()
  |> should.equal([])
}

// Test singleton

pub fn singleton_test() {
  differance.singleton(42)
  |> differance.to_list()
  |> should.equal([42])
}

// Test from_list and to_list

pub fn from_list_to_list_empty_test() {
  []
  |> differance.from_list
  |> differance.to_list
  |> should.equal([])
}

pub fn from_list_to_list_singleton_test() {
  [42]
  |> differance.from_list
  |> differance.to_list
  |> should.equal([42])
}

pub fn from_list_to_list_test() {
  [1, 3, 2, 42]
  |> differance.from_list
  |> differance.to_list
  |> should.equal([1, 3, 2, 42])
}

// Test append

pub fn append_empty_empty_test() {
  differance.append(differance.empty(), differance.empty())
  |> differance.to_list
  |> should.equal([])
}

pub fn append_empty_singleton_test() {
  differance.append(differance.empty(), differance.singleton(42))
  |> differance.to_list
  |> should.equal([42])
}

pub fn append_empty_nonempty_test() {
  differance.append(differance.empty(), differance.from_list([1, 3, 2, 42]))
  |> differance.to_list
  |> should.equal([1, 3, 2, 42])
}

pub fn append_singleton_empty_test() {
  differance.append(differance.singleton(42), differance.empty())
  |> differance.to_list
  |> should.equal([42])
}

pub fn append_singleton_singleton_test() {
  differance.append(differance.singleton(42), differance.singleton(24))
  |> differance.to_list
  |> should.equal([42, 24])
}

pub fn append_singleton_nonempty_test() {
  differance.append(differance.singleton(42), differance.from_list([1, 3, 2, 42]))
  |> differance.to_list
  |> should.equal([42, 1, 3, 2, 42])
}

pub fn append_nonempty_empty_test() {
  differance.append(differance.from_list([1, 3, 2, 42]), differance.empty())
  |> differance.to_list
  |> should.equal([1, 3, 2, 42])
}

pub fn append_nonempty_singleton_test() {
  differance.append(differance.from_list([1, 3, 2, 42]), differance.singleton(42))
  |> differance.to_list
  |> should.equal([1, 3, 2, 42, 42])
}

pub fn append_nonempty_nonempty_test() {
  differance.append(differance.from_list([1, 3, 2, 42]), differance.from_list([5, 3, 42, 1]))
  |> differance.to_list
  |> should.equal([1, 3, 2, 42, 5, 3, 42, 1])
}

// Test concat

pub fn concat_test() {
  [
    differance.from_list([1, 3, 42]),
    differance.from_list([5, 42, 7]),
    differance.from_list([]),
    differance.from_list([42]),
  ]
  |> differance.concat
  |> differance.to_list
  |> should.equal([1, 3, 42, 5, 42, 7, 42])
}

// Test length

pub fn length_empty_test() {
  differance.empty()
  |> differance.length
  |> should.equal(0)
}

pub fn length_singleton_test() {
  differance.singleton(42)
  |> differance.length
  |> should.equal(1)
}

pub fn length_test() {
  [1, 3, 2, 42]
  |> differance.from_list
  |> differance.length
  |> should.equal(4)
}

// Test reverse

pub fn reverse_empty_test() {
  differance.empty()
  |> differance.reverse
  |> differance.to_list
  |> should.equal([])
}

pub fn reverse_singleton_test() {
  differance.singleton(42)
  |> differance.reverse
  |> differance.to_list
  |> should.equal([42])
}

pub fn reverse_test() {
  [1, 3, 2, 42]
  |> differance.from_list
  |> differance.reverse
  |> differance.to_list
  |> should.equal([42, 2, 3, 1])
}


// Test head

pub fn head_empty_test() {
  differance.empty()
  |> differance.head
  |> should.equal(None)
}

pub fn head_singleton_test() {
  differance.singleton(42)
  |> differance.head
  |> should.equal(Some(42))
}

pub fn head_test() {
  [1, 3, 2, 42]
  |> differance.from_list
  |> differance.head
  |> should.equal(Some(1))
}

// Test tail

pub fn tail_empty_test() {
  differance.empty()
  |> differance.tail
  |> should.equal(None)
}

pub fn tail_singleton_test() {
  differance.singleton(42)
  |> differance.tail
  |> option.map(differance.to_list)
  |> should.equal(Some([]))
}

pub fn tail_test() {
  [1, 3, 2, 42]
  |> differance.from_list
  |> differance.tail
  |> option.map(differance.to_list)
  |> should.equal(Some([3, 2, 42]))
}

// Test zip

pub fn zip_empty_empty_test() {
  differance.zip(differance.empty(), differance.empty())
  |> differance.to_list
  |> should.equal([])
}

pub fn zip_empty_nonempty_test() {
  [1, 3, 2, 42]
  |> differance.from_list
  |> differance.zip(differance.empty(), _)
  |> differance.to_list
  |> should.equal([])
}

pub fn zip_nonempty_empty_test() {
  [1, 3, 2, 42]
  |> differance.from_list
  |> differance.zip(differance.empty())
  |> differance.to_list
  |> should.equal([])
}

pub fn zip_nonempty_nonempty_test() {
  differance.zip(differance.from_list([1, 3, 2, 42]), differance.from_list([3, 4, 24]))
  |> differance.to_list
  |> should.equal([#(1, 3), #(3, 4), #(2, 24)])
}

// Test map2

pub fn map2_empty_empty_test() {
  fn(a, b) { a + b }
  |> differance.map2(differance.empty(), differance.empty(), _)
  |> differance.to_list
  |> should.equal([])
}

pub fn map2_empty_nonempty_test() {
  fn(a, b) { a + b }
  |> differance.map2(differance.empty(), differance.from_list([1, 3, 2, 42]), _)
  |> differance.to_list
  |> should.equal([])
}

pub fn map2_nonempty_empty_test() {
  fn(a, b) { a + b }
  |> differance.map2(differance.empty(), differance.from_list([1, 3, 2, 42]), _)
  |> differance.to_list
  |> should.equal([])
}

pub fn map2_nonempty_nonempty_test() {
  fn(a, b) { a + b }
  |> differance.map2(differance.from_list([1, 3, 2, 42]), differance.from_list([3, 4, 24]), _)
  |> differance.to_list
  |> should.equal([4, 7, 26])
}

// Test map

pub fn map_empty_test() {
  differance.empty()
  |> differance.map(fn(a) { a + 1 })
  |> differance.to_list
  |> should.equal([])
}

pub fn map_singleton_test() {
  differance.singleton(42)
  |> differance.map(fn(a) { a + 1 })
  |> differance.to_list
  |> should.equal([43])
}

pub fn map_nonempty_test() {
  [1, 3, 2, 42]
  |> differance.from_list
  |> differance.map(fn(a) { a + 1 })
  |> differance.to_list
  |> should.equal([2, 4, 3, 43])
}

// Test fold

pub fn fold_empty_test() {
  differance.empty()
  |> differance.fold("123", string.append)
  |> should.equal("123")
}

pub fn fold_singleton_test() {
  differance.singleton("abc")
  |> differance.fold("123", string.append)
  |> should.equal("123abc")
}

pub fn fold_nonempty_test() {
  ["abc", "456", "def"]
  |> differance.from_list
  |> differance.fold("123", string.append)
  |> should.equal("123abc456def")
}

pub fn fold_right_empty_test() {
  differance.empty()
  |> differance.fold_right("123", string.append)
  |> should.equal("123")
}

pub fn fold_right_singleton_test() {
  differance.singleton("abc")
  |> differance.fold_right("123", string.append )
  |> should.equal("123abc")
}

pub fn fold_right_nonempty_test() {
  ["abc", "456", "def"]
  |> differance.from_list
  |> differance.fold_right("123", string.append)
  |> should.equal("123def456abc")
}
