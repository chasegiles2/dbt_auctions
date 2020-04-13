SELECT 
h.auction_id,
min(h.retrieval_time) AS min_retrieval_time,
max(h.retrieval_time) AS max_retrieval_time,
TIMESTAMPDIFF( second , min(h.retrieval_time) , max(h.retrieval_time) ) AS duration_seconds,
count(DISTINCT h.bidder) AS count_distinct_bidders,
count(*) AS count_total_bids,
sum(
    CASE
        WHEN h.bidder = a_1.winner THEN 1
        ELSE NULL
    END) AS count_winner_bids,
sum(
    CASE
        WHEN h.bid_method = 'Single Bid' THEN 1
        ELSE NULL
    END) AS count_single_bid,
sum(
    CASE
        WHEN h.bid_method = 'BidOMatic' THEN 1
        ELSE NULL
    END) AS count_bidomatic
FROM auctions.bid_history h
    JOIN auctions.auction a_1 ON h.auction_id = a_1.auction_id
GROUP BY 1