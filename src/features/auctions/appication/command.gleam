import features/auctions/model

pub type CreateAuction =
  fn(model.AuctionId) -> Result(Nil, String)
