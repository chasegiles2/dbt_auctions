SELECT
    a.auction_id,
    a.item_id,
    a.item_name,
    a.auction_link,
    a.winner,
    a.win_price,
    a.actual_price,
    a.voucher,
    a.bidomatic_on,
    a.actual_price - a.win_price AS price_difference,
    date_part('hour', s.min_retrieval_time) AS hour_of_day,
    s.min_retrieval_time,
    s.max_retrieval_time,
    s.duration_seconds,
        CASE
            WHEN l.price_when_locked IS NULL THEN false
            ELSE true
        END AS is_auction_locked,
    TIMESTAMPDIFF( second , l.retrieval_time_when_locked , s.max_retrieval_time ) AS duration_when_locked_seconds,
    l.price_when_locked,
    s.count_distinct_bidders,
    s.count_total_bids,
    s.count_single_bid,
    s.count_bidomatic,
    s.count_winner_bids
   FROM auctions.auction a
     LEFT JOIN {{ ref('aggregated_attributes') }} s ON a.auction_id = s.auction_id
     LEFT JOIN {{ ref('locked_attributes') }} l ON a.auction_id = l.auction_id
