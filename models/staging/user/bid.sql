Select
bid.bidder,
avg(bid_response_time_seconds) as avg_bid_response_time_seconds,
-- avg(case when bid_method = 'BidOMatic' then bid_response_time_seconds else NULL end) as avg_bid_response_time_seconds_bidomatic,
avg(case when bid_method = 'Single Bid' then bid_response_time_seconds else NULL end) as avg_bid_response_time_seconds_single,
avg(case when lock_state = True and bid_method = 'Single Bid' then bid_response_time_seconds else NULL end) as avg_bid_response_time_seconds_single_locked,
-- avg(case when lock_state = False and bid_method = 'Single Bid' then bid_response_time_seconds else NULL end) as avg_bid_response_time_seconds_single_not_locked,
sum(case when is_bid_back then 1 else 0 end) as count_bid_back,
-- sum(case when is_bid_back and bid_method = 'BidOMatic' then 1 else 0 end) as count_bid_back_bidomatic,
sum(case when is_bid_back and bid_method = 'Single Bid' then 1 else 0 end) as count_bid_back_single,
sum(case when is_bid_back and lock_state = True then 1 else 0 end) as count_bid_back_locked,
-- sum(case when is_bid_back and lock_state = True and bid_method = 'BidOMatic' then 1 else 0 end) as count_bid_back_bidomatic_locked,
sum(case when is_bid_back and lock_state = True and bid_method = 'Single Bid' then 1 else 0 end) as count_bid_back_single_locked,
sum(case when is_bid_back and lock_state = False then 1 else 0 end) as count_bid_back_not_locked,
-- sum(case when is_bid_back and lock_state = False and bid_method = 'BidOMatic'  then 1 else 0 end) as count_bid_back_bidomatic_not_locked,
sum(case when is_bid_back and lock_state = False and bid_method = 'Single Bid'  then 1 else 0 end) as count_bid_back_single_not_locked
FROM
(
    Select
    bidder,
    lock_state,
    bid_method,
    -- EXTRACT(epoch from h.retrieval_time - lag(h.retrieval_time,1) 
    --         Over (PARTITION BY h.auction_id ORDER BY  h.bid_number)) as bid_response_time_seconds,
    TIMESTAMPDIFF( second , lag(h.retrieval_time,1) Over (PARTITION BY h.auction_id ORDER BY  h.bid_number), h.retrieval_time) as bid_response_time_seconds,
    case when lag(h.bidder,2) Over (PARTITION BY h.auction_id ORDER BY  h.bid_number) = bidder 
        then true else false end as is_bid_back
    from auctions.bid_history h
    Where auction_time <= 10
) bid
Group by bid.bidder