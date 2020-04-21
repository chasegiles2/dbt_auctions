Select winner as bidder, sum(count_voucher_bids) as count_voucher_bids FROM
    (
		Select winner, cast(substring(item_name,1,position('-' in item_name) -1) as INTEGER) as count_voucher_bids
		from auctions.auction Where item_name like '%voucher%'
		Union ALL
		Select winner, cast(substring(voucher,1, position(' ' in voucher) - 1) as INTEGER) as count_voucher_bids
		from auctions.auction Where voucher != ''
		Union ALL
		/*added to capture all bidders making the join more clear in the result*/
		Select distinct bidder as winner, 0 as count_voucher_bids
		from auctions.bid_history
    ) t
    Group by winner