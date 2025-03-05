import gleam/list
import gleam/option.{type Option, None, Some}

/// A difference list is a way of representing a list that allows for the use 
/// of the "snoc" and "append" operations
/// in constant O(1) time.
pub type DList(a) =
  fn(List(a)) -> List(a)

/// An empty difference list
/// (DList, append, empty) is a monoid
///  
pub fn empty() -> DList(a) {
  fn(rest) { rest }
}

/// A dlist with a single element
///
pub fn singleton(elem: a) -> DList(a) {
  fn(rest) { [elem, ..rest] }
}

/// Collapses a dlist into a list
///
pub fn to_list(dlist: DList(a)) -> List(a) {
  dlist([])
}

/// Creates a dlist representing list
///
pub fn from_list(list: List(a)) -> DList(a) {
  fn(rest) { list.append(list, rest) }
}

/// Get the dlist that represents the concatenation of first and second
///
pub fn append(first: DList(a), with second: DList(a)) -> DList(a) {
  fn(rest) { rest |> second |> first }
}

/// Get a dlist that represents the concatenation of all given dlist
///
pub fn concat(dlists: List(DList(a))) -> DList(a) {
  dlists |> list.fold_right(empty(), append)
}

/// Counts the number of elements in a given dlist.
///
pub fn length(of dlist: DList(a)) -> Int {
  dlist |> to_list |> list.length
}

/// Creates a new dlist from a given dlist containing the same elements but
/// in the opposite order.
///
pub fn reverse(dlist: DList(a)) -> DList(a) {
  fn(rest) { rest |> dlist |> list.reverse }
}

/// Returns the first element of a dlist wrapped in an option
///
pub fn head(of dlist: DList(a)) -> Option(a) {
  case to_list(dlist) {
    [] -> None
    [x, ..] -> Some(x)
  }
}

/// Returns a dlist with the same elements excluding the first one
/// wrapped in an Option
/// 
pub fn tail(of dlist: DList(a)) -> Option(DList(a)) {
  case to_list(dlist) {
    [] -> None
    [_, ..rest] -> rest |> from_list |> Some
  }
}

/// Combines two dlists into a dlist of tuples of their elements
///
/// If a dlist is longer than the other the extra elements are dropped
///
pub fn zip(dlist: DList(a), with other: DList(b)) -> DList(#(a, b)) {
  fn(rest) {
    list.zip(to_list(dlist), to_list(other))
    |> list.append(rest)
  }
}

/// Creates a new dlist whose elements are the result of applying
/// the given function to the elements of the original list
/// 
pub fn map(dlist: DList(a), with f: fn(a) -> b) -> DList(b) {
  fn(rest) { dlist |> to_list |> list.map(f) |> list.append(rest) }
}

/// Combines two dlists into a single dlist using the given function
/// 
/// If a dlist is longer than the other the extra elements are dropped
///
pub fn map2(
  dlist1: DList(a),
  dlist2: DList(b),
  with f: fn(a, b) -> c,
) -> DList(c) {
  fn(rest) {
    list.map2(to_list(dlist1), to_list(dlist2), f)
    |> list.append(rest)
  }
}

/// Reduce a dlist into a single value by calling a given function
/// on each element from left to right
///  
pub fn fold(
  over dlist: DList(a),
  from initial: acc,
  with f: fn(acc, a) -> acc,
) -> acc {
  dlist |> to_list |> list.fold(initial, f)
}

/// Reduce a dlist into a single value by calling a given function
/// on each element from right to left
///
pub fn fold_right(
  over dlist: DList(a),
  from initial: acc,
  with f: fn(acc, a) -> acc,
) -> acc {
  dlist |> to_list |> list.fold_right(initial, f)
}
