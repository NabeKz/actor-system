import features/auctions/model

pub type SaveAuctionEvent =
  fn(model.AuctionEvent) -> Result(Nil, String)

pub type ApplyEvent =
  fn(model.AuctionEvent) -> Result(Nil, String)

pub type PlaceBid =
  fn(Int) -> Result(Nil, String)

pub fn invoke_create_auction(
  id: String,
  start_price: Int,
  save_event: SaveAuctionEvent,
  apply_event: ApplyEvent,
) -> Result(Nil, String) {
  let auction_id = model.new(id)
  let event = model.AuctionCreated(id: auction_id, start_price:)
  case save_event(event) {
    Ok(_) -> apply_event(event)
    Error(e) -> Error(e)
  }
}

pub fn invoke_bid(price: Int, place_bid: PlaceBid) -> Result(Nil, String) {
  price |> place_bid()
}
