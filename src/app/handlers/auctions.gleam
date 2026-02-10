import app/handlers/helpers
import features/auctions/application.{
  type ApplyEvent, type Dto, type GetAuctions, type SaveEvent,
}
import gleam/json
import shared/lib
import wisp.{type Request, type Response}

pub fn get_auctions(_req: Request, get_auctions: GetAuctions) -> Response {
  get_auctions()
  |> json.array(deserialize)
  |> json.to_string()
  |> wisp.json_response(200)
}

fn deserialize(dto: Dto) -> json.Json {
  let id = dto.auction_id |> application.auction_id_value()
  json.object([#("id", id |> json.string())])
}

pub fn create_auction(
  _req: Request,
  save_event: SaveEvent,
  apply_event: ApplyEvent,
  id_gen: lib.Generator(String),
) -> Response {
  id_gen()
  // TODO: start_priceをreqから取得
  |> application.invoke_create_auction(5000, save_event, apply_event)
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
