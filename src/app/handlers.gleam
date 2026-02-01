import app/handlers/account
import features/account/application/command
import features/account/model.{type AccountId}
import shared/lib
import wisp.{type Request, type Response}

pub type Handlers {
  Handlers(
    create_account: fn(Request) -> Response,
    get_account: fn(Request) -> Response,
  )
}

pub fn build(
  create: command.CreateAccount,
  id_gen: lib.Generator(AccountId),
) -> Handlers {
  Handlers(
    create_account: fn(req) { account.create_account(req, create, id_gen) },
    get_account: fn(_req) { account.get_account() },
  )
}
