defmodule EvemarketScanner do
	alias EvemarketScanner.{Repo, Character, EveClient, Urls}

  def wallet(character_name) do
		character = Repo.get_by!(Character, character_name: character_name)
		EveClient.get!(character, Urls.wallet(character.character_id))
	end

	def orders(character_name) do
		character = Repo.get_by!(Character, character_name: character_name)
		EveClient.get!(character, Urls.orders(character.character_id))
	end

	def transactions(character_name) do
		character = Repo.get_by!(Character, character_name: character_name)
		EveClient.get!(character, Urls.transactions(character.character_id))
	end

	def order_history(character_name, page \\ 1) do
		character = Repo.get_by!(Character, character_name: character_name)
		EveClient.get!(character, Urls.order_history(character.character_id, page))	
	end

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
