import app/composition
import app/routes
import gleam/erlang/process
import mist
import wisp
import wisp/wisp_mist

pub fn main() -> Nil {
  let secret_key_base = wisp.random_string(64)

  let assert Ok(handlers) = composition.build_handlers()

  let assert Ok(_) =
    routes.handle_request(handlers, _)
    |> wisp_mist.handler(secret_key_base)
    |> mist.new
    |> mist.bind("0.0.0.0")
    |> mist.port(5000)
    |> mist.start()

  process.sleep_forever()
}
