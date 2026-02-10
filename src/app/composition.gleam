import app/handlers.{type Handlers}
import features/account/adaptor/registry
import features/auctions/adaptor/actor as auction_actor
import features/auctions/adaptor/on_file
import gleam/otp/actor
import gleam/result
import shared/lib/uuid

pub fn build_handlers() -> Result(Handlers, actor.StartError) {
  use reg <- result.try(registry.start())
  let assert Ok(Nil) = on_file.init()

  let create = registry.create_account(reg)
  let id_gen = fn() { uuid.value(uuid.v4()) }

  let assert Ok(ac) = auction_actor.initialize()

  handlers.build(
    id_gen,
    create,
    on_file.save_event,
    auction_actor.apply_event(ac.data),
    on_file.get_auctions,
  )
  |> Ok()
}
