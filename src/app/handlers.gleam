import app/handlers/auctions
import features/auction/application
import wisp.{type Request, type Response}

import shared/lib

type Handler =
  fn(Request) -> Response

pub type Handlers {
  Handlers(
    create_auction: Handler,
    get_auction: fn(Request, String) -> Response,
    list_auctions: Handler,
  )
}

pub fn build(
  id_gen: lib.Generator(String),
  auction_port: application.AuctionPort,
) -> Handlers {
  let create_auction = auctions.create_auction(_, id_gen, auction_port.save)
  let get_auction = fn(req, id) {
    auctions.get_auction(req, id, auction_port.get_by_id)
  }
  let list_auctions = auctions.list_auctions(_, auction_port.get_list)

  Handlers(create_auction:, get_auction:, list_auctions:)
}
