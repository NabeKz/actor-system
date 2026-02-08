import app/handlers/account
import app/handlers/auctions
import features/account/application/command
import features/auctions/appication/query
import shared/lib
import wisp.{type Request, type Response}

pub type Handlers {
  Handlers(
    create_account: fn(Request) -> Response,
    get_auctions: fn(Request) -> Response,
  )
}

pub fn build(
  create: command.CreateAccount,
  get_auctions: query.GetAuctions,
  id_gen: lib.Generator(String),
) -> Handlers {
  Handlers(
    create_account: account.create_account(_, create, id_gen),
    get_auctions: auctions.get_auctions(_, get_auctions),
  )
}
