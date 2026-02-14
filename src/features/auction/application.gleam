import features/auction/model
import gleam/result
import shared/lib

pub type AuctionBidPlace =
  fn(Int) -> Result(Nil, String)

pub type SaveEvent =
  fn(model.AuctionEvent) -> Result(Nil, String)

// commandなのでResult(Nil, String)
pub type Save =
  fn(String, Int) -> Result(Nil, String)

pub type Update =
  fn(model.AuctionEvent) -> Result(Nil, String)

pub type AuctionPort {
  AuctionPort(save: Save)
}

pub fn invoke_create(
  id_gen: lib.Generator(String),
  price: Int,
  save: Save,
) -> Result(Nil, String) {
  use price <- result.try(price |> model.validate_price)

  id_gen()
  |> save(price)
}

pub fn invoke_bid_place() -> Result(String, Nil) {
  todo
}
