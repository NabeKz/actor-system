import app/context.{type Context}
import app/handlers/account
import wisp.{type Request, type Response}

pub type Handlers {
  Handlers(
    create_account: fn(Request) -> Response,
    get_account: fn(Request) -> Response,
  )
}

pub fn build(ctx: Context) -> Handlers {
  let create = context.create_account(ctx)
  let id_gen = context.id_generator(ctx)

  Handlers(
    create_account: fn(req) { account.create_account(req, create, id_gen) },
    get_account: fn(_req) { account.get_account() },
  )
}
