import app/handlers/helpers
import features/auctions/appication/command
import gleam/json
import shared/lib
import wisp.{type Request, type Response}

import features/auctions/appication/query
import features/auctions/application.{type CreateAuction}

pub fn get_auctions(_req: Request, get_auctions: query.GetAuctions) -> Response {
  get_auctions()
  |> json.array(deserialize)
  |> json.to_string()
  |> wisp.json_response(200)
}

fn deserialize(dto: query.Dto) -> json.Json {
  let id = dto.auction_id |> query.account_id_value()
  json.object([#("id", id |> json.string())])
}

pub fn create_auction(
  _req: Request,
  create_auction: CreateAuction,
  id_gen: lib.Generator(String),
) -> Response {
  id_gen()
  |> command.invoke_create_auction(create_auction)
  |> helpers.either(ok: create_success, error: create_failure)
}

fn create_success(_: Nil) {
  json.null()
  |> json.to_string()
  |> wisp.json_response(201)
}

fn create_failure(err: String) {
  err
  |> json.string
  |> json.to_string()
  |> wisp.json_response(400)
}
