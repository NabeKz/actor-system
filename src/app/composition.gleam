import features/auction/adaptor/actor
import features/auction/adaptor/on_ets
import features/auction/adaptor/on_file
import features/auction/adaptor/projection
import features/auction/application
import shared/event_bus
import shared/lib/file

import app/handlers
import shared/lib/uuid

const dir = "data"

pub fn build_handlers() {
  let id_gen = fn() { uuid.v4() |> uuid.value }

  let file = file.init(dir, "auction.txt")
  let save_event = on_file.save_event(file, _)

  let ets_table = on_ets.init()
  let get_list = fn() { on_ets.get_all(ets_table) }
  let restore_projection = on_ets.get(ets_table, _)

  let event_bus_subject =
    event_bus.initialize([
      projection.subscriber(fn(id, state) {
        on_ets.upsert(ets_table, id, state)
      }),
    ])
  let publish = event_bus.publish(event_bus_subject)

  let auction_subject =
    actor.initialize(fn() { file |> on_file.restore() }, save_event, publish)

  let auction_port =
    application.AuctionPort(
      save: actor.create(auction_subject),
      get_by_id: restore_projection,
      get_list: get_list,
    )

  handlers.build(id_gen, auction_port)
  |> Ok()
}
