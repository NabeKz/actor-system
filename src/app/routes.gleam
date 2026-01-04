import gleam/http.{Get, Post}
import gleam/json
import wisp.{type Request}

pub fn handle_request(req: Request) {
  let path = wisp.path_segments(req)

  case path, req.method {
    ["account"], Get -> get_account()
    ["account"], Post -> post_account()
    _, _ -> wisp.not_found()
  }
}

fn get_account() {
  json.string("ok")
  |> json.to_string()
  |> wisp.json_response(200)
}

fn post_account() {
  json.null()
  |> json.to_string()
  |> wisp.json_response(201)
}
