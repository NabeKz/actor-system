import features/auctions/model

pub type CreateAuction =
  fn(model.AuctionId) -> Result(Nil, String)

pub fn invoke_create_auction(id: String, create_auction: CreateAuction) {
  let auction_id = id |> model.new()
  auction_id |> create_auction
}
