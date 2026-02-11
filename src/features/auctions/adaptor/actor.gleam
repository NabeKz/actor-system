import features/auctions/appication/command
import features/auctions/application.{type SaveAuctionEvent}
import features/auctions/model.{type AuctionState}
import gleam/erlang/process.{type Subject}
import gleam/otp/actor
import gleam/result

type ActorState {
  ActorState(auction: AuctionState, save_event: SaveAuctionEvent)
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

pub fn initialize(save_event: SaveAuctionEvent) -> Subject(AuctionMessage) {
  let assert Ok(actor) =
    ActorState(auction: model.new_state(), save_event:)
    |> actor.new()
    |> actor.on_message(handle_message)
    |> actor.start()

  actor.data
}

pub fn create_auction(
  subject: Subject(AuctionMessage),
) -> application.CreateAuction {
  fn(id: model.AuctionId, start_price: Int) {
    actor.call(subject, 5000, Create(id, start_price, _))
  }
}

pub fn place_bid(subject: Subject(AuctionMessage)) -> command.PlaceBid {
  fn(price: Int) { actor.call(subject, 5000, Bid(price, _)) }
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
      let result = {
        use event <- result.try(state.auction |> model.validate_bid(price))
        use _ <- result.try(event |> state.save_event)
        let new_auction = model.apply(state.auction, event)
        Ok(new_auction)
      }

      case result {
        Ok(new_auction) -> {
          actor.send(reply_to, Ok(Nil))
          actor.continue(new_auction |> update(state))
        }
        Error(msg) -> {
          actor.send(reply_to, Error(msg))
          actor.continue(state)
        }
      }
    }
  }
}
