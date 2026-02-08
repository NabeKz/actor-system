import features/auctions/appication/command
import features/auctions/appication/query

pub type CreateAuction =
  command.CreateAuction

pub type GetAuctions =
  query.GetAuctions

pub type Dto =
  query.Dto

pub const invoke_get_auctions = query.invoke_get_auctions

pub const invoke_create_auction = command.invoke_create_auction

pub const auction_id_value = query.account_id_value
