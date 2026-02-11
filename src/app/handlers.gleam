import app/handlers/auctions
import features/auction/application
import wisp.{type Request, type Response}

import shared/lib

type Handler =
  fn(Request) -> Response

pub type Handlers {
<<<<<<< HEAD
  Handlers(
    create_auction: Handler,
    get_auction: fn(Request, String) -> Response,
    list_auctions: Handler,
  )
||||||| parent of 32058d6 (fix: typo)
  Handlers(get_auctions: fn(Request) -> Response, create_auctions: Handler)
=======
  Handlers(
    get_auctions: fn(Request) -> Response,
    create_auctions: Handler,
    auction_bid: Handler,
  )
>>>>>>> 32058d6 (fix: typo)
}

pub fn build(
  id_gen: lib.Generator(String),
  auction_port: application.AuctionPort,
) -> Handlers {
<<<<<<< HEAD
  let create_auction = auctions.create_auction(_, id_gen, auction_port.save)
  let get_auction = fn(req, id) {
    auctions.get_auction(req, id, auction_port.get_by_id)
  }
  let list_auctions = auctions.list_auctions(_, auction_port.get_list)

  Handlers(create_auction:, get_auction:, list_auctions:)
||||||| parent of 32058d6 (fix: typo)
  Handlers(
    get_auctions: auctions.get_auctions(_, auction_ports),
    create_auctions: auctions.create_auction(_, auction_ports, id_gen),
  )
=======
  Handlers(
    get_auctions: auctions.get_auctions(_, auction_ports),
    create_auctions: auctions.create_auction(_, auction_ports, id_gen),
    auction_bid: auctions.bid(_, auction_ports),
  )
>>>>>>> 32058d6 (fix: typo)
}
