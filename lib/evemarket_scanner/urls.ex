defmodule EvemarketScanner.Urls do
	def token(), do: "https://login.eveonline.com/oauth/token"

	def wallet(char_id), do: "https://esi.evetech.net/latest/characters/#{char_id}/wallet/"
	def orders(char_id), do: "https://esi.evetech.net/latest/characters/#{char_id}/orders/"
	def transactions(char_id), do: "https://esi.evetech.net/latest/characters/#{char_id}/wallet/transactions/"
	def type_orders(region_id, type_id, order_type \\ "all", page \\ 1), do: "https://esi.evetech.net/latest/markets/#{region_id}/orders/?order_type=#{order_type}&page=#{page}&type_id=#{type_id}"
	def order_history(char_id, page \\ 1), do: "https://esi.evetech.net/latest/characters/#{char_id}/orders/history/?page=#{page}"

	def type_info(type_id), do: "https://esi.evetech.net/latest/universe/types/#{type_id}?language=en-us"
	def group_info(group_id), do: "https://esi.evetech.net/latest/universe/groups/#{group_id}?language=en-us"
	def category_info(category_id), do: "https://esi.evetech.net/latest/universe/categories/#{category_id}?language=en-us"
	def category_ids(), do: "https://esi.evetech.net/latest/universe/categories"
end