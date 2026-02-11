import features/auctions/appication/command
import features/auctions/appication/query

pub type SavaAuctionEvent =
  command.SaveAuctionEvent

pub type AuctionPorts {
  AuctionPorts(
    save_event: command.SaveAuctionEvent,
    apply_event: command.ApplyEvent,
    get_auctions: query.GetAuctions,
  )
}

pub type Dto =
  query.Dto

pub const invoke_get_auctions = query.invoke_get_auctions

pub const invoke_create_auction = command.invoke_create_auction

pub const invoke_bid = command.invoke_bid

pub const auction_id_value = query.account_id_value
