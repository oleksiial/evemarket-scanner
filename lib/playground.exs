wheel_id = 33539
transactions = EvemarketScanner.transactions("Alex Prog")
	|> Enum.filter(fn x -> x["type_id"] == wheel_id end)

buy_t = transactions
	|> Enum.filter(fn x -> x["is_buy"] end)

sell_t = transactions
	|> Enum.filter(fn x -> !x["is_buy"] end)

buy_s = buy_t
	|> Enum.reduce(0, fn x, acc -> acc + x["unit_price"] * x["quantity"] end)

sell_s = sell_t
	|> Enum.reduce(0, fn x, acc -> acc + x["unit_price"] * x["quantity"] end)