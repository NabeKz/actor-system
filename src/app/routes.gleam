import app/context
import app/handlers/account as account_handler
import gleam/http.{Get, Post}
import gleam/json
import wisp.{type Request}

pub fn handle_request(ctx: context.Context, req: Request) {
  let path = wisp.path_segments(req)

  case path, req.method {
    [], Get -> health_check()
    ["health"], Get -> health_check()
    ["account"], Get -> account_handler.get_account()
    ["account"], Post ->
      account_handler.create_account(req, context.account_service(ctx))
    _, _ -> wisp.not_found()
  }
}

fn health_check() {
  json.object([#("status", json.string("ok"))])
  |> json.to_string()
  |> wisp.json_response(200)
}
