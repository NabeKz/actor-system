import features/auction/actor
import features/auction/application

import app/handlers.{type Handlers}
import shared/lib/uuid

pub fn build_handlers() {
  let id_gen = {
    fn() { uuid.v4() |> uuid.value }
  }

  let auction_subject = actor.initialize()
  let auction_port =
    application.AuctionPort(save: fn(_) { todo }, update: fn(_) { todo })

  handlers.build(id_gen, auction_port)
  |> Ok()
}
