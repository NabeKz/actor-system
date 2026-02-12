pub type AuctionState {
  NotStarted
  Started(id: String, price: Int)
}

pub type AuctionEvent {
  Created(id: String, price: Int)
  BidPlaced(id: String, price: Int)
}

pub fn init() -> AuctionState {
  NotStarted
}

pub fn apply(state: AuctionState, event: AuctionEvent) -> AuctionState {
  case event {
    Created(id, price) -> Started(id:, price:)
    BidPlaced(..) -> {
      todo
    }
  }
}
