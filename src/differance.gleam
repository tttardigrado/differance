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

/// A diff with a single element
///
pub fn singleton(elem: a) -> DList(a) {
  fn(rest) { [elem, ..rest] }
}

/// Collapses a diff into a list
///
pub fn to_list(diff: DList(a)) -> List(a) {
  diff([])
}

/// Creates a diff representing list
///
pub fn from_list(list: List(a)) -> DList(a) {
  fn(rest) { list.append(list, rest) }
}

/// Get the diff that represents the concatenation of first and second
///
pub fn append(first: DList(a), with second: DList(a)) -> DList(a) {
  fn(rest) { rest |> second |> first }
}

/// Get a diff that represents the concatenation of all given diff
///
pub fn concat(diffs: List(DList(a))) -> DList(a) {
  diffs |> list.fold(empty(), append)
}

/// Counts the number of elements in a given diff.
///
pub fn length(of diff: DList(a)) -> Int {
  diff |> to_list |> list.length
}

/// Creates a new diff from a given diff containing the same elements but
/// in the opposite order.
///
pub fn reverse(diff: DList(a)) -> DList(a) {
  fn(rest) { rest |> diff |> list.reverse }
}

/// Returns the first element of a diff wrapped in an option
///
pub fn head(of diff: DList(a)) -> Option(a) {
  case to_list(diff) {
    [] -> None
    [x, ..] -> Some(x)
  }
}

/// Returns a diff with the same elements excluding the first one
/// wrapped in an Option
/// 
pub fn tail(of diff: DList(a)) -> Option(DList(a)) {
  case to_list(diff) {
    [] -> None
    [_, ..rest] -> rest |> from_list |> Some
  }
}

/// Combines two diffs into a diff of tuples of their elements
///
/// If a diff is longer than the other the extra elements are dropped
///
pub fn zip(diff: DList(a), with other: DList(b)) -> DList(#(a, b)) {
  fn(rest) {
    list.zip(to_list(diff), to_list(other))
    |> list.append(rest)
  }
}

/// Creates a new diff whose elements are the result of applying
/// the given function to the elements of the original list
/// 
pub fn map(diff: DList(a), with f: fn(a) -> b) -> DList(b) {
  fn(rest) { diff |> to_list |> list.map(f) |> list.append(rest) }
}

/// Combines two diffs into a single diff using the given function
/// 
/// If a diff is longer than the other the extra elements are dropped
///
pub fn map2(
  diff1: DList(a),
  diff2: DList(b),
  with f: fn(a, b) -> c,
) -> DList(c) {
  fn(rest) {
    list.map2(to_list(diff1), to_list(diff2), f)
    |> list.append(rest)
  }
}

/// Reduce a diff into a single value by calling a given function
/// on each element from left to right
///  
pub fn fold(
  over diff: DList(a),
  from initial: acc,
  with f: fn(acc, a) -> acc,
) -> acc {
  diff |> to_list |> list.fold(initial, f)
}

/// Reduce a diff into a single value by calling a given function
/// on each element from right to left
///
pub fn fold_right(
  over diff: DList(a),
  from initial: acc,
  with f: fn(acc, a) -> acc,
) -> acc {
  diff |> to_list |> list.fold_right(initial, f)
}
