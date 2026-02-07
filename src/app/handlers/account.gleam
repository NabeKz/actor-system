import features/account/application/command
import features/account/application/query
import features/account/model.{type AccountId, AccountId}
import gleam/dynamic/decode
import gleam/json
import shared/lib
import wisp.{type Request, type Response}

pub fn create_account(
  req: Request,
  create: command.CreateAccount,
  generate_id: lib.Generator(AccountId),
) -> Response {
  use json_body <- wisp.require_json(req)

  let decoder = {
    use initial_balance <- decode.field("initial_balance", decode.int)
    decode.success(initial_balance)
  }

  case decode.run(json_body, decoder) {
    Ok(initial_balance) -> {
      case command.create_account(create, generate_id, initial_balance) {
        Ok(result) -> {
          let AccountId(id) = result.account_id
          json.object([
            #("account_id", json.string(id)),
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

pub fn get_account(
  _req: Request,
  get_balance: query.GetBalance,
  id: String,
) -> Response {
  let account_id = AccountId(id)

  case query.get_account(get_balance, account_id) {
    Ok(info) -> {
      let AccountId(account_id_str) = info.account_id
      json.object([
        #("account_id", json.string(account_id_str)),
        #("balance", json.int(info.balance)),
      ])
      |> json.to_string()
      |> wisp.json_response(200)
    }
    Error(error_msg) -> {
      json.object([#("error", json.string(error_msg))])
      |> json.to_string()
      |> wisp.json_response(404)
    }
  }
}

pub fn get_accounts(req: Request) -> Response {
  [#("data", json.string("ok"))]
  |> json.object()
  |> json.to_string()
  |> wisp.json_response(200)
}
