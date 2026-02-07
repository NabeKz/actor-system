pub opaque type AuctionId {
  AuctionId(String)
}

pub fn value(account_id: AuctionId) -> String {
  let AuctionId(value) = account_id
  value
}
