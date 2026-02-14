import features/auction/adaptor/actor
import features/auction/adaptor/on_file
import features/auction/application
import shared/lib/file

import app/handlers
import shared/lib/uuid

const dir = "data"

pub fn build_handlers() {
  let id_gen = {
    fn() { uuid.v4() |> uuid.value }
  }
  let file = file.init(dir, "auction.txt")
  let save_event = on_file.save_event(file, _)
  let auction_subject = actor.initialize(save_event)
  let auction_port =
    application.AuctionPort(save: actor.create(auction_subject))

  handlers.build(id_gen, auction_port)
  |> Ok()
}
