import features/auction/application
import features/auction/model
import gleam/result
import shared/lib

pub fn invoke_create(
  id_gen: lib.Generator(String),
  price: Int,
  save: application.Save,
) -> Result(Nil, String) {
  use price <- result.try(price |> model.validate_price)

  id_gen()
  |> save(price)
}
