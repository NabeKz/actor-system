import features/account/application/command
import features/account/model
import gleam/dynamic/decode
import gleam/json
import wisp.{type Request, type Response}

pub fn create_account(
  req: Request,
  account_command: command.AccountCommand,
) -> Response {
  use json_body <- wisp.require_json(req)

  let decoder = {
    use initial_balance <- decode.field("initial_balance", decode.int)
    decode.success(initial_balance)
  }

  case decode.run(json_body, decoder) {
    Ok(initial_balance) -> {
      case command.create_account(account_command, initial_balance) {
        Ok(result) -> {
          json.object([
            #("account_id", json.string(result.account_id)),
            #("balance", json.int(model.balance_to_int(result.balance))),
          ])
          |> json.to_string()
          |> wisp.json_response(201)
        }
        Error(error_msg) -> {
          echo error_msg
          wisp.internal_server_error()
        }
      }
    }
    Error(_) -> {
      wisp.unprocessable_content()
    }
  }
}

pub fn get_account() -> Response {
  json.string("ok")
  |> json.to_string()
  |> wisp.json_response(200)
}
