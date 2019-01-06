defmodule EvemarketScanner.EveClient do
	alias EvemarketScanner.{Repo, Character, Urls}

	def get!(character, url) do
		character = check_access_token(character) # check access_token and update if need
		headers = [{"Authorization", "Bearer " <> character.access_token}]
		HTTPoison.get!(url, headers).body |> Jason.decode!
	end

	def check_access_token(character) do
		if character.expires_at <= (DateTime.utc_now |> DateTime.to_unix) do
			refresh_token(character)
		else
			character
		end
	end

	def refresh_token(character) do
		headers = [
			{ "Content-Type", "application/json" },
			{
        "Authorization",
        "Basic #{
          Base.encode64("#{System.get_env("EVE_CLIENT_ID")}:#{System.get_env("EVE_CLIENT_SECRET")}")
        }"
      }
		]
		body = %{grant_type: "refresh_token", refresh_token: character.refresh_token} |> Jason.encode!
		response = HTTPoison.post!(Urls.token, body, headers).body |> Jason.decode!

		changeset = Character.changeset(character, %{
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
end