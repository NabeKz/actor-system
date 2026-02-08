import features/auctions/appication/query
import gleam/json
import wisp.{type Request, type Response}

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

pub fn create_auction(_req: Request) {
  json.null()
  |> json.to_string()
  |> wisp.json_response(201)
}
