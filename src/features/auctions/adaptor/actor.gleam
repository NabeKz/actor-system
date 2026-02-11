import features/auctions/application.{type SavaAuctionEvent}
import features/auctions/model.{type AuctionState}
import gleam/erlang/process.{type Subject}
import gleam/otp/actor

pub type ActorState {
  ActorState(auction: AuctionState, save_event: SavaAuctionEvent)
}

// actorに対して外部から可能な操作を書く
pub type AuctionMessage {
  Create(
    id: model.AuctionId,
    start_price: Int,
    // 返信が必要な場合のみreply_toを追加する
    reply_to: Subject(Result(Nil, String)),
  )
  Bid(price: Int, reply_to: Subject(Result(Nil, String)))
}

pub fn initialize(save_event: SavaAuctionEvent) -> Subject(AuctionMessage) {
  let assert Ok(actor) =
    ActorState(auction: model.new_state(), save_event:)
    |> actor.new()
    |> actor.on_message(handle_message)
    |> actor.start()

  actor.data
}

pub fn apply_event(subject: Subject(AuctionMessage)) {
  fn(event: model.AuctionEvent) {
    case event {
      model.AuctionCreated(id, start_price) -> {
        actor.call(subject, 5000, Create(id, start_price, _))
      }
      model.BidPlaced(_, price) -> {
        actor.call(subject, 5000, Bid(price, _))
      }
    }
  }
}

fn update(auction: AuctionState, state: ActorState) -> ActorState {
  ActorState(..state, auction:)
}

fn handle_message(
  state: ActorState,
  msg: AuctionMessage,
) -> actor.Next(ActorState, AuctionMessage) {
  case msg {
    Create(id, start_price, reply_to) -> {
      let event = model.AuctionCreated(id:, start_price:)
      let new_auction = model.apply(state.auction, event)
      // actor.sendは要するにreturn
      actor.send(reply_to, Ok(Nil))
      actor.continue(new_auction |> update(state))
    }
    Bid(price, reply_to) -> {
      let event = model.validate_bid(state.auction, price)

      case event {
        Ok(event) -> {
          let new_state = model.apply(state.auction, event)
          actor.send(reply_to, Ok(Nil))
          actor.continue(new_state |> update(state))
        }
        Error(msg) -> {
          actor.send(reply_to, Error(msg))
          actor.continue(state)
        }
      }
    }
  }
}
