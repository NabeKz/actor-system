import app/context
import features/account/registry
import gleam/dynamic/decode
import gleam/erlang/process
import gleam/http.{Get, Post}
import gleam/json
import shared/lib/uuid
import wisp.{type Request}

pub fn handle_request(ctx: context.Context, req: Request) {
  let path = wisp.path_segments(req)

  case path, req.method {
    ["account"], Get -> get_account()
    ["account"], Post -> post_account(req, ctx)
    _, _ -> wisp.not_found()
  }
}

fn get_account() {
  json.string("ok")
  |> json.to_string()
  |> wisp.json_response(200)
}

fn post_account(req: Request, ctx: context.Context) {
  use json <- wisp.require_json(req)

  let decoder = {
    use initial_balance <- decode.field("initial_balance", decode.int)
    decode.success(initial_balance)
  }

  case decode.run(json, decoder) {
    Ok(initial_balance) -> {
      let account_id = ctx |> context.generate_id()
      let registry_subject = ctx |> context.registry |> registry.subject
      let result =
        fn(reply_to) {
          registry.GetOrCreateAccount(
            account_id: uuid.value(account_id),
            initial_balance: initial_balance,
            reply_to: reply_to,
          )
        }
        |> process.call(registry_subject, 1000, _)
      case result {
        Ok(_) -> {
          json.object([
            #("acconut_id", json.string(uuid.value(account_id))),
            #("balance", json.int(initial_balance)),
          ])
          |> json.to_string()
          |> wisp.json_response(201)
        }
        Error(error_msg) -> {
          echo error_msg
          // Registry Actorからエラー返却
          wisp.internal_server_error()
        }
      }
    }
    Error(_) -> {
      wisp.internal_server_error()
    }
  }
}
