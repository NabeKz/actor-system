import gleam/otp/actor

import app/handlers.{type Handlers}
import shared/lib/uuid

pub fn build_handlers() -> Result(Handlers, actor.StartError) {
  let id_gen = {
    fn() { uuid.v4() |> uuid.value }
  }

  handlers.build(id_gen)
  |> Ok()
}
