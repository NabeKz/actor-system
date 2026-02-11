import app/handlers/helpers
import features/auctions/application.{type AuctionPorts, type Dto}
import gleam/json
import shared/lib
import wisp.{type Request, type Response}

pub fn get_auctions(_req: Request, ports: AuctionPorts) -> Response {
  ports.get_auctions()
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
  ports: AuctionPorts,
  id_gen: lib.Generator(String),
) -> Response {
  // TODO: start_priceをreqから取得
  let start_price = 5000
  id_gen()
  |> application.invoke_create_auction(
    start_price,
    ports.save_event,
    ports.apply_event,
  )
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
