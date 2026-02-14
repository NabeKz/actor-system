import features/auction/model.{type AuctionEvent}
import gleam/int
import gleam/list
import gleam/string
import shared/lib/file

pub fn save_event(file: file.File, event: AuctionEvent) -> Result(Nil, String) {
  let contents = case event {
    model.Created(id, price) -> ["Created", id, price |> int.to_string]
    model.BidPlaced(id, price) -> ["BidPlaced", id, price |> int.to_string]
  }

  file
  |> file.append(contents)
}

pub fn restore(file: file.File) -> List(AuctionEvent) {
  file
  |> file.rows
  |> list.map(deserialize)
}

fn deserialize(row: String) -> AuctionEvent {
  let assert [kind, id, price] = row |> string.split(",")
  let assert Ok(price) = int.parse(price)

  case kind {
    "Created" -> model.Created(id, price)
    "BidPlaced" -> model.BidPlaced(id, price)
    _ -> panic
  }
}
