import features/auction/model
import gleam/erlang/process.{type Subject}
import gleam/otp/actor

pub type ActorState {
  ActorState(auction: model.AuctionState)
}

pub type AuctionMessage {
  Creat(reply_to: Subject(Result(Nil, String)))
  Bid(reply_to: Subject(Result(Nil, String)))
}

pub fn initialize() -> Subject(AuctionMessage) {
  let assert Ok(ac) =
    model.init()
    |> ActorState(auction: _)
    |> actor.new()
    |> actor.on_message(handle_message)
    |> actor.start()

  ac.data
}

fn create() {
  todo
}

fn bid() {
  todo
}

fn handle_message(
  state: ActorState,
  message: AuctionMessage,
) -> actor.Next(ActorState, AuctionMessage) {
  case message {
    Creat(reply_to:) -> {
      actor.send(reply_to, Ok(Nil))
      actor.continue(state)
    }
    Bid(reply_to:) -> {
      actor.send(reply_to, Ok(Nil))
      actor.continue(state)
    }
  }
}
