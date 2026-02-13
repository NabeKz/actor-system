pub type AuctionEvent {
  Created(id: String, price: Int)
  BidPlaced(id: String, price: Int)
}

pub type AuctionState {
  NotStarted
  Started(id: String, price: Int)
}

pub fn init() -> AuctionState {
  NotStarted
}

pub fn apply(_state: AuctionState, event: AuctionEvent) -> AuctionState {
  case event {
    Created(id, price) -> Started(id:, price:)
    BidPlaced(id, price) -> Started(id:, price:)
  }
}

pub fn validate_update(current_price: Int, price: Int) -> Result(Int, String) {
  case price > current_price {
    True -> Ok(price)
    False -> Error("price must be gt current price")
  }
}

pub fn validate_price(value: Int) -> Result(Int, String) {
  case value > 0 {
    True -> Ok(value)
    False -> Error("price must be grater than 0")
  }
}
