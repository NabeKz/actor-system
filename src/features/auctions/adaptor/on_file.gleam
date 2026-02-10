import features/auctions/appication/query
import features/auctions/model
import gleam/list
import gleam/result
import simplifile

const data_dir = "data/auctions"

pub fn init() -> Result(Nil, simplifile.FileError) {
  simplifile.create_directory_all(data_dir)
}

pub fn get_auctions() -> List(query.Dto) {
  simplifile.read_directory(at: data_dir)
  |> result.unwrap([])
  |> list.map(fn(entry) { query.Dto(auction_id: model.new(entry)) })
}

pub fn save_event(event: model.AuctionEvent) -> Result(Nil, String) {
  case event {
    model.AuctionCreated(id, start_price) -> {
      let dir = data_dir <> "/" <> model.value(id)
      simplifile.create_directory(dir)
      |> result.map_error(simplifile.describe_error)
    }
  }
}
