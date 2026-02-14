import features/auction/cqrs/command
import features/auction/model

pub type SaveEvent =
  fn(model.AuctionEvent) -> Result(Nil, String)

pub type RestoreEvents =
  fn() -> List(model.AuctionEvent)

pub type UpsertProjection =
  fn(String, model.AuctionState) -> Result(Nil, String)

pub type RestoreProjection =
  fn(String) -> Result(model.AuctionState, String)

pub type ListProjection =
  fn() -> List(model.AuctionState)

pub type AuctionPort {
  AuctionPort(
    save: command.Save,
    get_by_id: RestoreProjection,
    get_list: ListProjection,
  )
}
