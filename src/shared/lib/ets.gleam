import gleam/erlang/atom.{type Atom}

pub type EtsTable

@external(erlang, "ets", "new")
pub fn new(name: Atom, opts: List(Atom)) -> EtsTable

@external(erlang, "ets", "insert")
pub fn insert(table: EtsTable, entry: #(String, value)) -> Bool

@external(erlang, "ets", "lookup")
pub fn lookup(table: EtsTable, key: String) -> List(#(String, value))

@external(erlang, "ets", "tab2list")
pub fn tab2list(table: EtsTable) -> List(#(String, value))
