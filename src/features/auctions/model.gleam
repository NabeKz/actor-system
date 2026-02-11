pub opaque type AuctionId {
  AuctionId(String)
}

pub fn new(id: String) -> AuctionId {
  AuctionId(id)
}

pub fn value(account_id: AuctionId) -> String {
  let AuctionId(value) = account_id
  value
}

pub type AuctionState {
  Waiting
  Started(auction_id: AuctionId, price: Int)
}

pub type AuctionEvent {
  AuctionCreated(id: AuctionId, start_price: Int)
  BidPlaced(id: AuctionId, price: Int)
}

pub fn new_state() -> AuctionState {
  Waiting
}

pub fn replay() {
  todo
}

pub fn apply(state: AuctionState, event: AuctionEvent) -> AuctionState {
  case event {
    AuctionCreated(id, price) -> Started(id, price:)
    BidPlaced(id, price) -> {
      case state {
        Started(..) -> {
          Started(id, price: price)
        }
        _ -> state
      }
    }
  }
}

pub fn validate_bid(
  state: AuctionState,
  price: Int,
) -> Result(AuctionEvent, String) {
  case state {
    Started(id, current_price) if price > current_price ->
      Ok(BidPlaced(id, price))
    Started(..) -> Error("入札額が現在の価格以下です")
    _ -> Error("オークションが開始されていません")
  }
}
