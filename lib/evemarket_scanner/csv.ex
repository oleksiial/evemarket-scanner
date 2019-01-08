defmodule EvemarketScanner.Csv do
	alias EvemarketScanner.{Repo, Type}

	def	write_csv!(path, data) do
		File.write!(path, Enum.join(data, ",") <> "\n", [:append])
	end

	def fetch_all_margins() do
		margins = Repo.all(Type)
			|> Enum.map(&fetch_margin(&1))
			|> Enum.map(fn {k, v} -> k <> "," <> Float.to_string(v) <> "\n" end)
		File.write!("margin.csv", margins)
	end

	def fetch_margins(types) do
		margins = types
			|> Enum.map(&fetch_margin(&1))
			|> Enum.map(fn {k, v} -> k <> "," <> Float.to_string(v) <> "\n" end)
		File.write!("margin.csv", margins)
	end

	def fetch_margin(type, region_id \\ 10000002 ) do
		margin = EvemarketScanner.type_orders_margin(region_id, type.type_id)
		{ type.name, margin }
	end
end