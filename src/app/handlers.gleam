import wisp.{type Request, type Response}

import app/handlers/account
import app/handlers/auctions
import features/account/application/command
import features/auctions/application.{type CreateAuction, type GetAuctions}
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
  create_auction: CreateAuction,
  get_auctions: GetAuctions,
) -> Handlers {
  Handlers(
    create_account: account.create_account(_, create, id_gen),
    get_auctions: auctions.get_auctions(_, get_auctions),
    create_auctions: auctions.create_auction(_, create_auction, id_gen),
  )
}
