import features/auctions/model

pub type SaveEvent =
  fn(model.AuctionEvent) -> Result(Nil, String)

pub type ApplyEvent =
  fn(model.AuctionEvent) -> Result(Nil, String)

pub fn invoke_create_auction(
  id: String,
  start_price: Int,
  save_event: SaveEvent,
  apply_event: ApplyEvent,
) {
  let auction_id = model.new(id)
  let event = model.AuctionCreated(id: auction_id, start_price:)
  case save_event(event) {
    Ok(_) -> apply_event(event)
    Error(e) -> Error(e)
  }
}
