import wisp.{type Request, type Response}

import app/handlers/account
import app/handlers/auctions
import features/account/application/command
import features/auctions/application.{
  type ApplyEvent, type GetAuctions, type SaveAuctionEvent,
}
import shared/lib

type Handler =
  fn(Request) -> Response

pub type Handlers {
  Handlers(
    create_account: fn(Request) -> Response,
    get_auctions: fn(Request) -> Response,
    create_auctions: Handler,
  )
}

pub fn build(
  id_gen: lib.Generator(String),
  create: command.CreateAccount,
  save_event: SaveAuctionEvent,
  apply_event: ApplyEvent,
  get_auctions: GetAuctions,
) -> Handlers {
  Handlers(
    create_account: account.create_account(_, create, id_gen),
    get_auctions: auctions.get_auctions(_, get_auctions),
    create_auctions: auctions.create_auction(_, save_event, apply_event, id_gen),
  )
}
