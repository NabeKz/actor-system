import app/handlers/helpers
import features/auction/application
import features/auction/cqrs/command
import shared/lib
import wisp

pub fn create_auction(
  _req: wisp.Request,
  id: lib.Generator(String),
  save: application.Save,
) {
  let price = 5000

  command.invoke_create(id, price, save)
  |> helpers.either(create_success, create_failure)
}

fn create_success(_: Nil) {
  wisp.created()
}

fn create_failure(_msg: String) {
  wisp.bad_request("bad request")
}
