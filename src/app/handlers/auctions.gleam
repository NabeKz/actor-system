import app/handlers/helpers
import features/auction/application
import features/auction/cqrs/command
import features/auction/model
import gleam/json
import gleam/list
import shared/lib
import wisp

pub fn create_auction(
  _req: wisp.Request,
  id: lib.Generator(String),
  save: command.Save,
) {
  let price = 5000

  command.invoke_create(id, price, save)
  |> helpers.either(create_success, create_failure)
}

fn create_success(_: Nil) {
  wisp.created()
}

fn create_failure(_msg: String) {
  wisp.bad_request("bad request")
}

pub fn get_auction(
  _req: wisp.Request,
  id: String,
  get_by_id: application.RestoreProjection,
) {
  get_by_id(id)
  |> helpers.either(ok: auction_to_json_response, error: fn(_) {
    wisp.not_found()
  })
}

pub fn list_auctions(_req: wisp.Request, get_list: application.ListProjection) {
  get_list()
  |> list.map(auction_to_json)
  |> json.preprocessed_array
  |> json.to_string
  |> wisp.json_response(200)
}

fn auction_to_json_response(state: model.AuctionState) {
  auction_to_json(state)
  |> json.to_string
  |> wisp.json_response(200)
}

fn auction_to_json(state: model.AuctionState) -> json.Json {
  case state {
    model.NotStarted -> json.object([#("status", json.string("not_started"))])
    model.Started(id, price) ->
      json.object([
        #("id", json.string(id)),
        #("price", json.int(price)),
        #("status", json.string("started")),
      ])
  }
}
