import app/routes
import gleam/erlang/process
import mist
import wisp
import wisp/wisp_mist

pub fn main() -> Nil {
  let secret_key_base = wisp.random_string(64)

  let assert Ok(_) =
    wisp_mist.handler(routes.handle_request, secret_key_base)
    |> mist.new
    |> mist.port(5000)
    |> mist.start

  process.sleep_forever()
}

fn make_process() {
  todo
}
