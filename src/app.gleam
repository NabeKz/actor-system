import app/context
import app/handlers
import app/routes
import gleam/erlang/process
import mist
import wisp
import wisp/wisp_mist

pub fn main() -> Nil {
  let secret_key_base = wisp.random_string(64)

  let assert Ok(ctx) = context.initialize()
  let h = handlers.build(ctx)

  let assert Ok(_) =
    wisp_mist.handler(routes.handle_request(h, _), secret_key_base)
    |> mist.new
    |> mist.bind("0.0.0.0")
    |> mist.port(5000)
    |> mist.start

  process.sleep_forever()
}
