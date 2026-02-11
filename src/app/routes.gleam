import app/handlers.{type Handlers}
import gleam/http.{Get, Post}
import gleam/json
import wisp.{type Request, type Response}

pub fn handle_request(h: Handlers, req: Request) -> Response {
  case wisp.path_segments(req), req.method {
    [], Get -> health_check()
    ["health"], Get -> health_check()
    ["auctions"], Get -> {
      todo
    }
    ["auctions"], Post -> {
      todo
    }
    _, _ -> wisp.not_found()
  }
}

fn health_check() -> Response {
  json.object([#("status", json.string("ok"))])
  |> json.to_string()
  |> wisp.json_response(200)
}
