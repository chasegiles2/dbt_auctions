--opportunity to use jinja for case statements???
Select
b.bidder,
count(*) as count_bids,
sum(case when bid_method = 'Single Bid' then 1 else 0 end)+ 1 as count_single_bid,
sum(case when bid_method = 'BidOMatic' then 1 else 0 end)+ 1 as count_bidomatic_bid,
sum(case when lock_state = True then 1 else 0 end) + 1 as count_bid_locked,
sum(case when lock_state = False then 1 else 0 end) + 1 as count_bid_not_locked,
sum(case when bid_method = 'Single Bid' and lock_state = False then 1 else 0 end) + 1 as count_single_bid_not_locked,
sum(case when bid_method = 'Single Bid' and lock_state = True then 1 else 0 end) + 1 as count_single_bid_locked,
sum(case when bid_method = 'BidOMatic' and lock_state = False then 1 else 0 end) + 1 as count_bidomatic_bid_not_locked,
sum(case when bid_method = 'BidOMatic' and lock_state = True then 1 else 0 end) + 1 as count_bidomatic_bid_locked,
count(distinct auction_id) as count_auctions,
min(retrieval_time) as min_retrieval_time,
max(retrieval_time) as max_retrieval_time,
TIMESTAMPDIFF( day , min(retrieval_time) , max(retrieval_time) ) AS duration_days,
Count(DISTINCT DATE(retrieval_time)) count_active_days,
case when max(retrieval_time) > current_date - interval '21 days' then true else false end as is_currently_active
From auctions.bid_history b
Group by bidder