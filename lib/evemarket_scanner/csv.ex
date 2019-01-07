defmodule EvemarketScanner.Csv do
	alias EvemarketScanner.{Repo, Type}

	def fetch_all_margins() do
		Repo.all(Type)
			|> Enum.map(&fetch_margin(&1))
	end

	def fetch_margin(type, region_id \\ 10000002 ) do
		margin = EvemarketScanner.type_orders_margin(region_id, type.type_id)
		{ type.name, margin }
	end
end