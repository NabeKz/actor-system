import features/auction/model

type GetAuctions =
  fn() -> List(model.AuctionState)

pub fn invoke_list(get_auctions: GetAuctions) {
  get_auctions()
}
