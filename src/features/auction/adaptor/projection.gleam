import features/auction/application
import features/auction/model
import shared/event_bus

pub fn subscriber(
  upsert: application.UpsertProjection,
) -> event_bus.Subscriber(model.AuctionEvent) {
  fn(event: model.AuctionEvent) {
    case event {
      model.Created(id, _) | model.BidPlaced(id, _) -> {
        let state = model.apply(model.NotStarted, event)
        let _ = upsert(id, state)
        Nil
      }
    }
  }
}
