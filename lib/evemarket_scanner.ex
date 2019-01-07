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

	def process_transactions(transactions) do
		t_buy = transactions |> Enum.filter(&(&1.is_buy))
		t_sell = transactions |> Enum.filter(&(!&1.is_buy))
		n_buy = t_buy |> Enum.count
		n_sell = t_sell |> Enum.count
		total_buy = t_buy |> Enum.reduce(0, &(&1.quantity * &1.unit_price + &2))
		total_sell = t_sell |> Enum.reduce(0, &(&1.quantity * &1.unit_price + &2))
		%{buy: %{n: n_buy, total: total_buy}, sell: %{n: n_sell, total: total_sell}}
	end

	def transactions_by_type(type_id, character_name \\ "Alex Prog", start_date \\ "0001-01-01", end_date \\ "9999-12-31") do
		transactions(character_name, start_date, end_date)
		|> Enum.filter(&(&1.type_id === type_id))
	end

	def transactions(character_name \\ "Alex Prog", start_date \\ "0001-01-01", end_date \\ "9999-12-31") do
		character = Repo.get_by!(Character, character_name: character_name)
		start_date = start_date |> EvemarketScanner.Helpers.date_to_datetime
		end_date = end_date |> EvemarketScanner.Helpers.date_to_datetime
		EveClient.get!(character, Urls.transactions(character.character_id))
		|> Enum.filter(fn t ->
				t_date = EvemarketScanner.Helpers.cast_date(t.date)
				Timex.diff(start_date, t_date) < 0 and Timex.diff(end_date, t_date) > 0
			end)
		|> Enum.map(&Map.take(&1, ~w(date is_buy quantity type_id unit_price)a))
	end

	def order_history(character_name \\ "Alex Prog", page \\ 1) do
		character = Repo.get_by!(Character, character_name: character_name)
		EveClient.get!(character, Urls.order_history(character.character_id, page))	
	end

	def sell_orders_to_update(character_name \\ "Alex Prog") do
		orders = character_name |> orders() |> Enum.filter(&(!(&1 |> Map.has_key?(:is_buy_order))))
		orders 
			|> Enum.map(&(&1.type_id))
			|> Enum.map(fn type ->
					my_type_orders = orders |> Enum.filter(&(&1.type_id == type))
					my_type_orders_count = my_type_orders |> Enum.count()
					type_orders = type_orders(10000002, type, "sell")
					type_on_top? = type_orders
						|> Enum.filter(&(&1.location_id === Enum.at(my_type_orders, 0).location_id)) #!!!
						|> Enum.sort(&(&1.price < &2.price))
						|> Enum.take(my_type_orders_count)
						|> Enum.all?(fn order ->
							Enum.find_value(my_type_orders, &(
								&1.order_id == order.order_id
							))
						end)
					if !type_on_top?, do: type, else: nil
				end)
			|> Enum.filter(&(&1) != nil)
			|> types_info()
			|> Enum.map(&(&1.name))
	end

	def buy_orders_to_update(character_name \\ "Alex Prog") do
		orders = character_name |> orders() |> Enum.filter(&((&1 |> Map.has_key?(:is_buy_order))))
		orders 
			|> Enum.map(&(&1.type_id))
			|> Enum.map(fn type ->
					my_type_orders = orders |> Enum.filter(&(&1.type_id == type))
					my_type_orders_count = my_type_orders |> Enum.count()
					type_on_top? = type_orders(10000002, type, "buy")
						|> Enum.sort(&(&1.price > &2.price))
						|> Enum.take(my_type_orders_count)
						|> Enum.all?(fn order ->
							Enum.find_value(my_type_orders, &(&1.order_id == order.order_id))
						end)
					if !type_on_top?, do: type, else: nil
				end)
			|> Enum.filter(&(&1) != nil)
			|> types_info()
			|> Enum.map(&(&1.name))
	end

	def type_orders(region_id, type_id, order_type \\ "all", page \\ 1) do
		EveClient.get!(Urls.type_orders(region_id, type_id, order_type, page))
	end

	def type_orders_margin(region_id, type_id) do
		sell_orders = type_orders(region_id, type_id, "sell") |> Enum.take(-1)
		buy_orders = type_orders(region_id, type_id, "buy") |> Enum.take(-1)
		if sell_orders == [] or buy_orders == [] do
			-100.0
		else
			last_sell_order = hd sell_orders
			last_buy_order = hd buy_orders

			diff = last_sell_order.price * (1-0.025-0.010) - last_buy_order.price * (1+0.003)
			diff / (last_buy_order.price * (1+0.003)) * 100
		end
	end

	def type_info(name) when is_binary(name), do: type_info(Repo.get_by(Type, name: name), nil)
	def type_info(id) when is_number(id), do: type_info(Repo.get(Type, id), id)	
	defp type_info(nil, nil), do: :not_found
	defp type_info(nil, id) do
		id 
			|> Urls.type_info()
			|> EveClient.get!()
			|> Repo.create_type 
	end
	defp type_info(type, _id), do: type

	def types_info(type_ids), do: type_ids |> Enum.map(&type_info(&1))

	def groups_info(group_ids) do
		Enum.reduce(group_ids, [], fn x, acc -> acc ++ [(EveClient.get!(Urls.group_info(x)))] end)
		|> Enum.filter(fn x -> x.published == true end)
	end
	
	def categories_info, do: categories_info(EveClient.get!(Urls.category_ids))
	def categories_info(category_ids) do
		Enum.reduce(category_ids, [], fn x, acc -> acc ++ [(EveClient.get!(Urls.category_info(x)))] end)
		|> Enum.filter(fn x -> x.published == true end)
	end

	def route_length(origin, destination) do
		EveClient.get!(Urls.route(origin, destination))
			|> Enum.count
			|> Kernel.-(1)
	end
end
