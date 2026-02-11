import wisp.{type Request, type Response}

import shared/lib

type Handler =
  fn(Request) -> Response

pub type Handlers {
  Handlers
}

pub fn build(id_gen: lib.Generator(String)) -> Handlers {
  Handlers
}
