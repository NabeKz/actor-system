import app/handlers/account
import app/handlers/auctions
import features/account/application/command
import features/account/model.{type AccountId}
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
  id_gen: lib.Generator(AccountId),
) -> Handlers {
  Handlers(
    create_account: fn(req) { account.create_account(req, create, id_gen) },
    get_auctions: fn(req) { auctions.get_auctions(req, get_auctions) },
  )
}
