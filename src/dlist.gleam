import gleam/list
import gleam/option.{type Option, None, Some}

pub type DList(a) =
  fn(List(a)) -> List(a)

pub fn empty() -> DList(a) {
  fn(rst) { rst }
}

pub fn to_list(dlist: DList(a)) -> List(a) {
  dlist([])
}

pub fn from_list(list: List(a)) -> DList(a) {
  fn(rest) { list.append(list, rest) }
}

pub fn append(first: DList(a), with second: DList(a)) -> DList(a) {
  fn(rest) { rest |> second |> first }
}

pub fn length(of dlist: DList(a)) -> Int {
  dlist |> to_list |> list.length
}

pub fn reverse(dlist: DList(a)) -> DList(a) {
  fn(rest) { rest |> dlist |> list.reverse }
}

pub fn head(of dlist: DList(a)) -> Option(a) {
  case to_list(dlist) {
    [] -> None
    [x, ..] -> Some(x)
  }
}

pub fn tail(of dlist: DList(a)) -> Option(DList(a)) {
  case to_list(dlist) {
    [] -> None
    [_, ..rest] -> rest |> from_list |> Some
  }
}

pub fn zip(dlist: DList(a), with other: DList(b)) -> DList(#(a, b)) {
  fn(rest) {
    list.zip(to_list(dlist), to_list(other))
    |> list.append(rest)
  }
}

pub fn map(dlist: DList(a), with f: fn(a) -> b) -> DList(b) {
  fn(rest) { dlist |> to_list |> list.map(f) |> list.append(rest) }
}

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

pub fn fold(
  over dlist: DList(a),
  from initial: acc,
  with f: fn(acc, a) -> acc,
) -> acc {
  dlist |> to_list |> list.fold(initial, f)
}

pub fn fold_right(
  over dlist: DList(a),
  from initial: acc,
  with f: fn(acc, a) -> acc,
) -> acc {
  dlist |> to_list |> list.fold_right(initial, f)
}
