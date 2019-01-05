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

		changeset = Character.changeset(char, %{
			access_token: response["access_token"],
			expires_at: add_seconds_to_utc_now(response["expires_in"])
		})

		Repo.update! changeset
	end

	def add_seconds_to_utc_now(seconds) do
		DateTime.utc_now 
			|> DateTime.to_unix()
			|> Kernel.+(seconds)
	end

  def wallet(character_name) do
		char = Repo.get_by!(Character, character_name: character_name)
		access_token = char.access_token
		character_id = char.character_id

		url = "https://esi.evetech.net/latest/characters/#{character_id}/wallet/"
		headers = [{"Authorization", "Bearer " <> access_token}]
		HTTPoison.get!(url, headers).body
	end
end
