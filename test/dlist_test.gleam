import dlist
import gleeunit
import gleeunit/should
import gleam/option.{None, Some}


pub fn main() {
  gleeunit.main()
}

// Test empty 
pub fn empty_test() {
  dlist.empty()
  |> dlist.to_list()
  |> should.equal([])
}

// Test singleton

pub fn singleton_test() {
  dlist.singleton(42)
  |> dlist.to_list()
  |> should.equal([42])
}

// Test from_list and to_list

pub fn from_list_to_list_empty_test() {
  []
  |> dlist.from_list
  |> dlist.to_list
  |> should.equal([])
}

pub fn from_list_to_list_singleton_test() {
  [42]
  |> dlist.from_list
  |> dlist.to_list
  |> should.equal([42])
}

pub fn from_list_to_list_test() {
  [1, 3, 2, 42]
  |> dlist.from_list
  |> dlist.to_list
  |> should.equal([1, 3, 2, 42])
}

// Test append

pub fn append_empty_empty_test() {
  dlist.append(dlist.empty(), dlist.empty())
  |> dlist.to_list
  |> should.equal([])
}

pub fn append_empty_singleton_test() {
  dlist.append(dlist.empty(), dlist.singleton(42))
  |> dlist.to_list
  |> should.equal([42])
}

pub fn append_empty_nonempty_test() {
  dlist.append(dlist.empty(), dlist.from_list([1, 3, 2, 42]))
  |> dlist.to_list
  |> should.equal([1, 3, 2, 42])
}

pub fn append_singleton_empty_test() {
  dlist.append(dlist.singleton(42), dlist.empty())
  |> dlist.to_list
  |> should.equal([42])
}

pub fn append_singleton_singleton_test() {
  dlist.append(dlist.singleton(42), dlist.singleton(24))
  |> dlist.to_list
  |> should.equal([42, 24])
}

pub fn append_singleton_nonempty_test() {
  dlist.append(dlist.singleton(42), dlist.from_list([1, 3, 2, 42]))
  |> dlist.to_list
  |> should.equal([42, 1, 3, 2, 42])
}

pub fn append_nonempty_empty_test() {
  dlist.append(dlist.from_list([1, 3, 2, 42]), dlist.empty())
  |> dlist.to_list
  |> should.equal([1, 3, 2, 42])
}

pub fn append_nonempty_singleton_test() {
  dlist.append(dlist.from_list([1, 3, 2, 42]), dlist.singleton(42))
  |> dlist.to_list
  |> should.equal([1, 3, 2, 42, 42])
}

pub fn append_nonempty_nonempty_test() {
  dlist.append(dlist.from_list([1, 3, 2, 42]), dlist.from_list([5, 3, 42, 1]))
  |> dlist.to_list
  |> should.equal([1, 3, 2, 42, 5, 3, 42, 1])
}

// Test concat

pub fn concat_test() {
  [
    dlist.from_list([1, 3, 42]),
    dlist.from_list([5, 42, 7]),
    dlist.from_list([]),
    dlist.from_list([42]),
  ]
  |> dlist.concat
  |> dlist.to_list
  |> should.equal([1, 3, 42, 5, 42, 7, 42])
}

// Test length

pub fn length_empty_test() {
  dlist.empty()
  |> dlist.length
  |> should.equal(0)
}

pub fn length_singleton_test() {
  dlist.singleton(42)
  |> dlist.length
  |> should.equal(1)
}

pub fn length_test() {
  [1, 3, 2, 42]
  |> dlist.from_list
  |> dlist.length
  |> should.equal(4)
}

// Test reverse

pub fn reverse_empty_test() {
  dlist.empty()
  |> dlist.reverse
  |> dlist.to_list
  |> should.equal([])
}

pub fn reverse_singleton_test() {
  dlist.singleton(42)
  |> dlist.reverse
  |> dlist.to_list
  |> should.equal([42])
}

pub fn reverse_test() {
  [1, 3, 2, 42]
  |> dlist.from_list
  |> dlist.reverse
  |> dlist.to_list
  |> should.equal([42, 2, 3, 1])
}


// Test head

pub fn head_empty_test() {
  dlist.empty()
  |> dlist.head
  |> should.equal(None)
}

pub fn head_singleton_test() {
  dlist.singleton(42)
  |> dlist.head
  |> should.equal(Some(42))
}

pub fn head_test() {
  [1, 3, 2, 42]
  |> dlist.from_list
  |> dlist.head
  |> should.equal(Some(1))
}

// Test tail

pub fn tail_empty_test() {
  dlist.empty()
  |> dlist.tail
  |> should.equal(None)
}

pub fn tail_singleton_test() {
  dlist.singleton(42)
  |> dlist.tail
  |> option.map(dlist.to_list)
  |> should.equal(Some([]))
}

pub fn tail_test() {
  [1, 3, 2, 42]
  |> dlist.from_list
  |> dlist.tail
  |> option.map(dlist.to_list)
  |> should.equal(Some([3, 2, 42]))
}
