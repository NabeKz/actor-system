import app/handlers/account
import features/account/application/command
import features/account/application/query
import features/account/model.{type AccountId}
import shared/lib
import wisp.{type Request, type Response}

pub type Handlers {
  Handlers(
    create_account: fn(Request) -> Response,
    get_account: fn(Request, String) -> Response,
    get_accounts: fn(Request) -> Response,
  )
}

pub fn build(
  create: command.CreateAccount,
  id_gen: lib.Generator(AccountId),
  get_balance: query.GetBalance,
) -> Handlers {
  Handlers(
    create_account: fn(req) { account.create_account(req, create, id_gen) },
    get_account: fn(req, id) { account.get_account(req, get_balance, id) },
    get_accounts: fn(req) { account.get_accounts(req) },
  )
}
