import app/handlers/auctions
import features/auction/application
import wisp.{type Request, type Response}

import shared/lib

type Handler =
  fn(Request) -> Response

pub type Handlers {
  Handlers(create_auction: Handler)
}

pub fn build(
  id_gen: lib.Generator(String),
  auction_port: application.AuctionPort,
) -> Handlers {
  let create_auction = auctions.create_auction(_, id_gen, auction_port.save)

  Handlers(create_auction:)
}
