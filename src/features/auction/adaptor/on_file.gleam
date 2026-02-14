import features/auction/model.{type AuctionEvent}
import gleam/int
import shared/lib/file

pub fn save_event(file: file.File, event: AuctionEvent) -> Result(Nil, String) {
  let contents = case event {
    model.Created(id, price) -> ["Created", id, price |> int.to_string]
    model.BidPlaced(id, price) -> ["BidPlaced", id, price |> int.to_string]
  }

  file
  |> file.append(contents)
}
