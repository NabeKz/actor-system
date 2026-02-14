import features/auction/model

pub type SaveEvent =
  fn(model.AuctionEvent) -> Result(Nil, String)

pub type Save =
  fn(String, Int) -> Result(Nil, String)

pub type AuctionPort {
  AuctionPort(save: Save)
}
