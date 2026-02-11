import features/auction/adaptor/actor
import features/auction/adaptor/on_ets
import features/auction/adaptor/on_file
import features/auction/application
import shared/lib/file

import app/handlers
import shared/lib/uuid

const dir = "data"

pub fn build_handlers() {
  let id_gen = fn() { uuid.v4() |> uuid.value }

<<<<<<< HEAD
  let file = file.init(dir, "auction.txt")
  let save_event = on_file.save_event(file, _)

  let ets_table = on_ets.init()
  let upsert_projection = fn(id, state) { on_ets.upsert(ets_table, id, state) }
  let restore_projection = on_ets.get(ets_table, _)

  let auction_subject =
    actor.initialize(
      fn() { file |> on_file.restore() },
      save_event,
      upsert_projection,
||||||| parent of 32058d6 (fix: typo)
  let subject = on_file.save_event |> auction_actor.initialize
  let auction_ports =
    AuctionPorts(
      save_event: on_file.save_event,
      apply_event: auction_actor.apply_event(subject),
      get_auctions: on_file.get_auctions,
=======
  let subject = on_file.save_event |> auction_actor.initialize
  let auction_ports =
    AuctionPorts(
      save_event: on_file.save_event,
      create_auction: auction_actor.create_auction(subject),
      get_auctions: on_file.get_auctions,
      bid: auction_actor.place_bid(subject),
>>>>>>> 32058d6 (fix: typo)
    )

  let auction_port =
    application.AuctionPort(
      save: actor.create(auction_subject),
      get_by_id: restore_projection,
      get_list: fn() { on_ets.get_all(ets_table) },
    )

  handlers.build(id_gen, auction_port)
  |> Ok()
}
