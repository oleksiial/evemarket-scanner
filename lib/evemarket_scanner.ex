defmodule EvemarketScanner do

	alias EvemarketScanner.{Repo, Character}

	def refresh_token do
		char = Repo.all(Character) |> Enum.at(0)

		url = "https://login.eveonline.com/oauth/token"
		headers = [
			{ "Content-Type", "application/json" },
			{
        "Authorization",
        "Basic #{
          Base.encode64("#{System.get_env("EVE_CLIENT_ID")}:#{System.get_env("EVE_CLIENT_SECRET")}")
        }"
      }
		]
		params = %{
			grant_type: "refresh_token",
      refresh_token: char.refresh_token
		}
		body = Jason.encode! params

		response = HTTPoison.post!(url, body, headers).body |> Jason.decode!

		# changeset = Character.changeset(char, %{access_token: response.access_token})
	end

  def wallet do

		char = Repo.all(Character) |> Enum.at(0)
		access_token = char.access_token

		url = "https://esi.evetech.net/latest/characters/2112161508/wallet/"
		headers = [{"Authorization", "Bearer " <> access_token}]
		HTTPoison.get url, headers
	end
end
