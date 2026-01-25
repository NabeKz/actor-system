//// This module contains the code to run the sql queries defined in
//// `./src/features/account/sql`.
//// > 🐿️ This module was generated automatically using v4.6.0 of
//// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
////

import gleam/dynamic/decode
import gleam/json.{type Json}
import gleam/option.{type Option}
import gleam/time/timestamp.{type Timestamp}
import pog

/// A row you get from running the `get_events` query
/// defined in `./src/features/account/sql/get_events.sql`.
///
/// > 🐿️ This type definition was generated automatically using v4.6.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type GetEventsRow {
  GetEventsRow(
    id: Int,
    account_id: String,
    event_type: String,
    payload: String,
    timestamp: Int,
    created_at: Option(Timestamp),
  )
}

/// Runs the `get_events` query
/// defined in `./src/features/account/sql/get_events.sql`.
///
/// > 🐿️ This function was generated automatically using v4.6.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn get_events(
  db: pog.Connection,
  arg_1: String,
) -> Result(pog.Returned(GetEventsRow), pog.QueryError) {
  let decoder = {
    use id <- decode.field(0, decode.int)
    use account_id <- decode.field(1, decode.string)
    use event_type <- decode.field(2, decode.string)
    use payload <- decode.field(3, decode.string)
    use timestamp <- decode.field(4, decode.int)
    use created_at <- decode.field(5, decode.optional(pog.timestamp_decoder()))
    decode.success(GetEventsRow(
      id:,
      account_id:,
      event_type:,
      payload:,
      timestamp:,
      created_at:,
    ))
  }

  "SELECT id, account_id, event_type, payload, timestamp, created_at
FROM account_events
WHERE account_id = $1
ORDER BY id ASC
"
  |> pog.query
  |> pog.parameter(pog.text(arg_1))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `save_event` query
/// defined in `./src/features/account/sql/save_event.sql`.
///
/// > 🐿️ This type definition was generated automatically using v4.6.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type SaveEventRow {
  SaveEventRow(id: Int, created_at: Option(Timestamp))
}

/// Runs the `save_event` query
/// defined in `./src/features/account/sql/save_event.sql`.
///
/// > 🐿️ This function was generated automatically using v4.6.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn save_event(
  db: pog.Connection,
  arg_1: String,
  arg_2: String,
  arg_3: Json,
  arg_4: Int,
) -> Result(pog.Returned(SaveEventRow), pog.QueryError) {
  let decoder = {
    use id <- decode.field(0, decode.int)
    use created_at <- decode.field(1, decode.optional(pog.timestamp_decoder()))
    decode.success(SaveEventRow(id:, created_at:))
  }

  "INSERT INTO account_events (account_id, event_type, payload, timestamp)
VALUES ($1, $2, $3, $4)
RETURNING id, created_at
"
  |> pog.query
  |> pog.parameter(pog.text(arg_1))
  |> pog.parameter(pog.text(arg_2))
  |> pog.parameter(pog.text(json.to_string(arg_3)))
  |> pog.parameter(pog.int(arg_4))
  |> pog.returning(decoder)
  |> pog.execute(db)
}
