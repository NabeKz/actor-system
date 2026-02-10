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
  Started(auction_id: AuctionId, start_price: Int)
}

pub type AuctionEvent {
  AuctionCreated(id: AuctionId, start_price: Int)
}

pub fn new_state() -> AuctionState {
  Waiting
}

pub fn replay() {
  todo
}

pub fn apply(_state: AuctionState, event: AuctionEvent) -> AuctionState {
  case event {
    AuctionCreated(id, start_price) -> Started(id, start_price:)
  }
}
