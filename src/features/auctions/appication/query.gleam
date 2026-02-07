import features/auctions/model

pub type Dto {
  Dto(auction_id: model.AuctionId)
}

pub type GetAuctions =
  fn() -> List(Dto)

pub fn invoke_get_auctions(query: GetAuctions) -> List(Dto) {
  query()
}

pub const account_id_value = model.value
