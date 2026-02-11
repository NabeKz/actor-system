import wisp.{type Request, type Response}

import app/handlers/auctions
import features/auctions/application.{type AuctionPorts}
import shared/lib

type Handler =
  fn(Request) -> Response

pub type Handlers {
  Handlers(get_auctions: fn(Request) -> Response, create_auctions: Handler)
}

pub fn build(
  id_gen: lib.Generator(String),
  auction_ports: AuctionPorts,
) -> Handlers {
  Handlers(
    get_auctions: auctions.get_auctions(_, auction_ports),
    create_auctions: auctions.create_auction(_, auction_ports, id_gen),
  )
}
