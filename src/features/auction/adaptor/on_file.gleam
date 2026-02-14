import features/auction/model.{type AuctionEvent}
import gleam/int
import shared/lib/file

pub fn save_event(file: file.File, event: AuctionEvent) -> Result(Nil, String) {
  let contents = [event.id, event.price |> int.to_string]

  file
  |> file.append(contents)
}
