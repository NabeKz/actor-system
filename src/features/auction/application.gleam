import features/auction/cqrs/command
import features/auction/model

pub type SaveEvent =
  fn(model.AuctionEvent) -> Result(Nil, String)

pub type AuctionPort {
  AuctionPort(save: command.Save)
}
