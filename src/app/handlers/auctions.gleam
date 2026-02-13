import app/handlers/helpers
import features/auction/application
import shared/lib
import wisp

pub fn create_auction(
  _req: wisp.Request,
  id: lib.Generator(String),
  save: application.Save,
  update: application.Update,
) {
  let price = 5000

  application.invoke_create(id, price, save, update)
  |> helpers.either(create_success, create_failure)
}

fn create_success(_: Nil) {
  wisp.created()
}

fn create_failure(_: String) {
  wisp.bad_request("bad request")
}
