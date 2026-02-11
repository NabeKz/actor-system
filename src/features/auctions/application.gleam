import features/auctions/appication/command
import features/auctions/appication/query

pub type SaveAuctionEvent =
  command.SaveAuctionEvent

pub type CreateAuction =
  command.CreateAuction

pub type AuctionPorts {
  AuctionPorts(
    save_event: command.SaveAuctionEvent,
    create_auction: command.CreateAuction,
    get_auctions: query.GetAuctions,
    bid: command.PlaceBid,
  )
}

pub type Dto =
  query.Dto

pub const invoke_get_auctions = query.invoke_get_auctions

pub const invoke_create_auction = command.invoke_create_auction

pub const invoke_bid = command.invoke_bid

pub const auction_id_value = query.account_id_value
