import features/auction/adaptor/actor
import features/auction/application

import app/handlers.{type Handlers}
import shared/lib/uuid

pub fn build_handlers() {
  let id_gen = {
    fn() { uuid.v4() |> uuid.value }
  }
  let save_event = fn(_) { todo }
  let auction_subject = actor.initialize(save_event)
  let auction_port =
    application.AuctionPort(save: actor.create(auction_subject), update: fn(_) {
      todo
    })

  handlers.build(id_gen, auction_port)
  |> Ok()
}
