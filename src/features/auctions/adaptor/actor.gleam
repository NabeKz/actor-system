import features/auctions/model
import gleam/erlang/process.{type Subject}
import gleam/otp/actor

// actorに対して外部から可能な操作を書く
pub type AuctionMessage {
  Create(
    id: model.AuctionId,
    start_price: Int,
    // 返信が必要な場合のみreply_toを追加する
    reply_to: Subject(Result(Nil, String)),
  )
}

pub fn initialize() -> Result(
  actor.Started(Subject(AuctionMessage)),
  actor.StartError,
) {
  model.new_state()
  |> actor.new()
  |> actor.on_message(handle_message)
  |> actor.start()
}

fn handle_message(
  state: model.AuctionState,
  msg: AuctionMessage,
) -> actor.Next(model.AuctionState, AuctionMessage) {
  case msg {
    Create(id, start_price, reply_to) -> {
      let event = model.AuctionCreated(id:, start_price:)
      let new_state = model.apply(state, event)

      actor.send(reply_to, Ok(Nil))
      actor.continue(new_state)
    }
  }
}
