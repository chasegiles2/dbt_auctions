Select
    t.bidder,
    round(max(count_bids_over_max_bids_ratio),3) as max_bid_ratio,
    sum(CASE WHEN is_auction_locked THEN 1 ELSE 0 END) as count_auctions_locked,
    sum(CASE WHEN is_winner THEN 1 ELSE 0 END) as count_wins,
    sum(CASE WHEN is_winner and is_auction_locked THEN 1 ELSE 0 END) as count_wins_locked,
    sum(CASE WHEN is_winner THEN price_difference ELSE 0 END) as sum_value_won
    From
    (
        Select h.auction_id, h.bidder,
        a.actual_price/0.4 as max_bids_per_user,
        count(*)/(a.actual_price/0.4) as count_bids_over_max_bids_ratio,
        (a.actual_price - a.win_price) as price_difference,
        case when h.bidder = a.winner then true else false end as is_winner,
        boolor_agg(h.lock_state) as is_auction_locked
        from auctions.bid_history h
        Inner Join auctions.auction a on h.auction_id = a.auction_id
        Group by h.auction_id, h.bidder, a.actual_price, a.win_price, a.winner
    ) t
    Group by t.bidder