defmodule EvemarketScanner do
	alias EvemarketScanner.{Repo, Character, EveClient, Urls, Type}

  def wallet(character_name \\ "Alex Prog") do
		character = Repo.get_by!(Character, character_name: character_name)
		EveClient.get!(character, Urls.wallet(character.character_id))
	end

	def orders(character_name \\ "Alex Prog") do
		character = Repo.get_by!(Character, character_name: character_name)
		EveClient.get!(character, Urls.orders(character.character_id))
	end

	def transactions(character_name \\ "Alex Prog") do
		character = Repo.get_by!(Character, character_name: character_name)
		EveClient.get!(character, Urls.transactions(character.character_id))
	end

	def order_history(character_name \\ "Alex Prog", page \\ 1) do
		character = Repo.get_by!(Character, character_name: character_name)
		EveClient.get!(character, Urls.order_history(character.character_id, page))	
	end

	def type_orders(region_id, type_id, order_type \\ "all", page \\ 1) do
		HTTPoison.get!(Urls.type_orders(region_id, type_id, order_type, page)).body |> Jason.decode!
	end
	def type_orders_margin(region_id, type_id) do
		last_sell_order = hd type_orders(region_id, type_id, "sell") |> Enum.take(-1)
		last_buy_order = hd type_orders(region_id, type_id, "buy") |> Enum.take(-1)
		diff = last_sell_order["price"] * (1-0.025-0.010)  - last_buy_order["price"] * (1+0.003)
		diff / (last_buy_order["price"] * (1+0.003)) * 100
	end

	def type_info(name), do: [Repo.get_by!(Type, name: name).type_id] |> types_info()
	def types_info(type_ids) do
		Enum.reduce type_ids, [], fn x, acc -> acc ++ [(HTTPoison.get!(Urls.type_info(x)).body |> Jason.decode!)] end
	end

	def groups_info(group_ids) do
		Enum.reduce(group_ids, [], fn x, acc -> acc ++ [(HTTPoison.get!(Urls.group_info(x)).body |> Jason.decode!)] end)
		|> Enum.filter(fn x -> x["published"] == true end)
	end
	
	def categories_info, do: categories_info(HTTPoison.get!(Urls.category_ids).body |> Jason.decode!)
	def categories_info(category_ids) do
		Enum.reduce(category_ids, [], fn x, acc -> acc ++ [(HTTPoison.get!(Urls.category_info(x)).body |> Jason.decode!)] end)
		|> Enum.filter(fn x -> x["published"] == true end)
	end
end
