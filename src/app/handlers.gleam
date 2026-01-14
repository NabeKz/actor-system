import app/context.{type Context}
import app/handlers/account
import features/account/application/command
import features/account/application/query
import wisp.{type Request, type Response}

pub type Handlers {
  Handlers(
    create_account: fn(Request) -> Response,
    get_account: fn(Request) -> Response,
  )
}

pub fn build(ctx: Context) -> Handlers {
  let repo = ctx |> context.repository()
  let id_gen = ctx |> context.id_generator()

  let cmd = repo |> command.new(id_gen)
  let _qry = repo |> query.new

  Handlers(
    create_account: fn(req) { account.create_account(req, cmd) },
    get_account: fn(_req) { account.get_account() },
  )
}
