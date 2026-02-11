import gleam/int
import gleam/list
import gleam/result
import simplifile

import features/auctions/appication/query
import features/auctions/model.{AuctionCreated}
import shared/lib/file

const file = file.File("data", "auctions.txt")

pub fn init() -> Result(Nil, simplifile.FileError) {
  file |> file.init()
}

pub fn get_auctions() -> List(query.Dto) {
  file
  |> file.rows()
  |> list.map(fn(entry) { query.Dto(auction_id: model.new(entry)) })
}

pub fn save_event(event: model.AuctionEvent) -> Result(Nil, String) {
  case event {
    AuctionCreated(id, start_price) -> {
      let row = [id |> model.value(), start_price |> int.to_string()]

      file
      |> file.append(file.ListValue(row))
      |> result.map_error(simplifile.describe_error)
    }
  }
}
