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
