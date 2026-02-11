import gleam/otp/actor

import app/handlers.{type Handlers}
import features/auctions/adaptor/actor as auction_actor
import features/auctions/adaptor/on_file
import features/auctions/application.{AuctionPorts}
import shared/lib/uuid

pub fn build_handlers() -> Result(Handlers, actor.StartError) {
  let assert Ok(Nil) = on_file.init()

  let id_gen = {
    fn() { uuid.v4() |> uuid.value }
  }

  let subject = on_file.save_event |> auction_actor.initialize
  let auction_ports =
    AuctionPorts(
      save_event: on_file.save_event,
      apply_event: auction_actor.apply_event(subject),
      get_auctions: on_file.get_auctions,
    )

  handlers.build(id_gen, auction_ports)
  |> Ok()
}
