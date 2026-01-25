import gleam/erlang/atom.{type Atom}
import gleam/erlang/process.{type Subject}
import gleam/otp/actor
import gleam/result

// --- ETS external bindings ---

type EtsTable

@external(erlang, "ets", "new")
fn ets_new(name: Atom, opts: List(Atom)) -> EtsTable

@external(erlang, "ets", "lookup")
fn ets_lookup(table: EtsTable, key: String) -> List(#(String, Subject(msg)))

@external(erlang, "ets", "insert")
fn ets_insert(table: EtsTable, entry: #(String, Subject(msg))) -> Bool

// --- Locker Actor (直列化のみ) ---

type LockerMessage(msg) {
  CreateIfNotExists(
    id: String,
    factory: fn() -> Result(Subject(msg), actor.StartError),
    reply_to: Subject(Result(Subject(msg), String)),
  )
  CreateOnly(
    id: String,
    factory: fn() -> Result(Subject(msg), actor.StartError),
    reply_to: Subject(Result(Subject(msg), String)),
  )
}

type LockerState {
  LockerState(table: EtsTable)
}

// --- Public API ---

pub opaque type Registry(msg) {
  Registry(table: EtsTable, locker: Subject(LockerMessage(msg)))
}

pub fn start() -> Result(Registry(msg), actor.StartError) {
  // ETS テーブル作成
  let table =
    ets_new(atom.create("registry"), [
      atom.create("set"),
      atom.create("public"),
    ])

  // Locker Actor 起動
  let initial_state = LockerState(table: table)

  initial_state
  |> actor.new()
  |> actor.on_message(handle_locker_message)
  |> actor.start()
  |> result.map(fn(started) { Registry(table: table, locker: started.data) })
}

/// 読み取り専用 (ETS 直接、高速)
pub fn get(registry: Registry(msg), id: String) -> Result(Subject(msg), String) {
  let Registry(table, ..) = registry

  case ets_lookup(table, id) {
    [#(_, subject)] -> Ok(subject)
    _ -> Error("Not found")
  }
}

/// create (存在すればエラー、なければ作成)
pub fn create(
  registry: Registry(msg),
  id: String,
  factory: fn() -> Result(Subject(msg), actor.StartError),
) -> Result(Subject(msg), String) {
  let Registry(table, locker) = registry

  // 高速パス: ETS に既にあれば即座にエラー
  case ets_lookup(table, id) {
    [#(_, _)] -> Error("Already exists")
    _ -> {
      // 遅いパス: Actor 経由で作成（競合時もエラー）
      process.call(locker, 5000, CreateOnly(id, factory, _))
    }
  }
}

/// get_or_create (Actor 経由で原子性保証)
pub fn get_or_create(
  registry: Registry(msg),
  id: String,
  factory: fn() -> Result(Subject(msg), actor.StartError),
) -> Result(Subject(msg), String) {
  let Registry(table, locker) = registry

  // 高速パス: ETS に既にあれば即座に返す
  case ets_lookup(table, id) {
    [#(_, subject)] -> Ok(subject)
    _ -> {
      // 遅いパス: Actor 経由で作成
      process.call(locker, 5000, CreateIfNotExists(id, factory, _))
    }
  }
}

// --- Locker Actor handler ---

fn handle_locker_message(
  state: LockerState,
  message: LockerMessage(msg),
) -> actor.Next(LockerState, LockerMessage(msg)) {
  let LockerState(table) = state

  let result = case message {
    CreateIfNotExists(id, factory, reply_to) -> {
      let res = case ets_lookup(table, id) {
        [#(_, subject)] -> Ok(subject)
        _ -> create_and_insert(table, id, factory)
      }
      process.send(reply_to, res)
    }
    CreateOnly(id, factory, reply_to) -> {
      let res = case ets_lookup(table, id) {
        [#(_, _)] -> Error("Already exists")
        _ -> create_and_insert(table, id, factory)
      }
      process.send(reply_to, res)
    }
  }

  let _ = result
  actor.continue(state)
}

fn create_and_insert(
  table: EtsTable,
  id: String,
  factory: fn() -> Result(Subject(msg), actor.StartError),
) -> Result(Subject(msg), String) {
  factory()
  |> result.map(fn(subject) {
    ets_insert(table, #(id, subject))
    subject
  })
  |> result.map_error(fn(_) { "Failed to create actor" })
}
