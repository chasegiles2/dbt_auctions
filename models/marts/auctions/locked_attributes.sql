Select
	h.auction_id,
	price_when_locked,
	h.retrieval_time as retrieval_time_when_locked
	from auctions.bid_history h
	Inner Join
	(
		Select
		h.auction_id,
		min(h.price) as price_when_locked
		from auctions.bid_history h
		Where h.lock_state = true
		Group by h.auction_id
	) lock_price
	On h.auction_id = lock_price.auction_id and h.price = lock_price.price_when_locked