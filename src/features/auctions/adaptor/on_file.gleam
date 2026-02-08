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

pub fn save_auction(auction_id: model.AuctionId) -> Result(Nil, String) {
  simplifile.create_directory(data_dir <> "/" <> model.value(auction_id))
  |> result.map_error(simplifile.describe_error)
}
