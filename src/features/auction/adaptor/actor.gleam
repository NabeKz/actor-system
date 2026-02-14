import features/auction/application.{type RestoreEvents, type SaveEvent}
import features/auction/model
import gleam/erlang/process.{type Subject}
import gleam/otp/actor

pub type ActorState {
  ActorState(
    auction: model.AuctionState,
    save_event: SaveEvent,
    upsert_projection: application.UpsertProjection,
  )
}

pub type AuctionMessage {
  Create(id: String, price: Int, reply_to: Subject(Result(Nil, String)))
  Bid(reply_to: Subject(Result(Nil, String)))
}

pub fn initialize(
  restore_events: RestoreEvents,
  save_event: SaveEvent,
  upsert_projection: application.UpsertProjection,
) -> Subject(AuctionMessage) {
  let assert Ok(ac) =
    restore_events()
    |> model.replay
    |> ActorState(auction: _, save_event:, upsert_projection:)
    |> actor.new()
    |> actor.on_message(handle_message)
    |> actor.start()

  ac.data
}

pub fn create(subject: Subject(AuctionMessage)) {
  fn(id: String, price: Int) { actor.call(subject, 5000, Create(id, price, _)) }
}

fn handle_message(
  state: ActorState,
  message: AuctionMessage,
) -> actor.Next(ActorState, AuctionMessage) {
  case message {
    Create(id:, price:, reply_to:) -> {
      let event = model.Created(id, price)
      let result = state.save_event(event)
      case result {
        Ok(_) -> {
          let auction = model.apply(state.auction, event)
          let _ = state.upsert_projection(id, auction)
          actor.send(reply_to, Ok(Nil))
          actor.continue(ActorState(..state, auction:))
        }
        Error(msg) -> {
          actor.send(reply_to, Error(msg))
          actor.continue(state)
        }
      }
    }
    Bid(reply_to:) -> {
      actor.send(reply_to, Ok(Nil))
      actor.continue(state)
    }
  }
}
