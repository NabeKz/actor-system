import features/auctions/appication/command
import features/auctions/appication/query

pub const auction_query = query.invoke_get_auctions

pub type CreateAuction =
  command.CreateAuction
