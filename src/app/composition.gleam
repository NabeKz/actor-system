import app/handlers.{type Handlers}
import features/account/adaptor/registry
import features/auctions/adaptor/on_file
import gleam/otp/actor
import gleam/result
import shared/lib/uuid

pub fn build_handlers() -> Result(Handlers, actor.StartError) {
  use reg <- result.try(registry.start())
  let assert Ok(Nil) = on_file.init()

  let create = registry.create_account(reg)
  let id_gen = fn() { uuid.value(uuid.v4()) }

  handlers.build(create, on_file.get_auctions, id_gen)
  |> Ok()
}
