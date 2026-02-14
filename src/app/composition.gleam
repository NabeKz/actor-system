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
