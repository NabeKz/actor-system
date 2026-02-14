import features/auction/model.{type AuctionState}
import gleam/erlang/atom
import gleam/list
import shared/lib/ets

pub fn init() -> ets.EtsTable {
  ets.new(atom.create("auction_projection"), [
    atom.create("set"),
    atom.create("public"),
  ])
}

pub fn upsert(
  table: ets.EtsTable,
  id: String,
  state: AuctionState,
) -> Result(Nil, String) {
  ets.insert(table, #(id, state))
  Ok(Nil)
}

pub fn get(table: ets.EtsTable, id: String) -> Result(AuctionState, String) {
  case ets.lookup(table, id) {
    [#(_, state)] -> Ok(state)
    _ -> Error("Not found")
  }
}

pub fn get_all(table: ets.EtsTable) -> List(AuctionState) {
  ets.tab2list(table)
  |> list.map(fn(entry) { entry.1 })
}
