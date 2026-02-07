import app/handlers.{type Handlers}
import features/account/adaptor/registry
import features/account/model.{AccountId}
import gleam/otp/actor
import gleam/result
import shared/lib/uuid

pub fn build_handlers() -> Result(Handlers, actor.StartError) {
  use reg <- result.try(registry.start())

  let create = registry.create_account(reg)
  let id_gen = fn() { AccountId(uuid.value(uuid.v4())) }
  let get_balance = registry.get_balance(reg)

  handlers.build(create, id_gen, get_balance)
  |> Ok()
}
