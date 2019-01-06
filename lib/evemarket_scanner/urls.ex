defmodule EvemarketScanner.Urls do
	def token(), do: "https://login.eveonline.com/oauth/token"

	def wallet(char_id), do: "https://esi.evetech.net/latest/characters/#{char_id}/wallet/"
	def orders(char_id), do: "https://esi.evetech.net/latest/characters/#{char_id}/orders/"
	def transactions(char_id) do
		"https://esi.evetech.net/latest/characters/#{char_id}/wallet/transactions/"
	end

	def order_history(char_id, page \\ 1) do
		"https://esi.evetech.net/latest/characters/#{char_id}/orders/history/?page=#{page}"
	end

	def type_info(type_id), do: "https://esi.evetech.net/latest/universe/types/#{type_id}?language=en-us"
	def group_info(group_id), do: "https://esi.evetech.net/latest/universe/groups/#{group_id}?language=en-us"
	def category_info(category_id), do: "https://esi.evetech.net/latest/universe/categories/#{category_id}?language=en-us"
	def category_ids(), do: "https://esi.evetech.net/latest/universe/categories"
end