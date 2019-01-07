defmodule EvemarketScanner.EveClient do
	alias EvemarketScanner.{Repo, Character, Urls}

	def get!(character, url) do
		character = check_access_token(character) # check access_token and update if need
		headers = [{"Authorization", "Bearer " <> character.access_token}]
		HTTPoison.get!(url, headers).body |> Jason.decode!(keys: :atoms)
	end

	def get!(url) do
		{:ok, response_body} = get(url)
		response_body
	end
	def get(url) do
		case HTTPoison.get(url) do
			{:ok, %HTTPoison.Response{status_code: 200, body: body}} -> 
				{:ok, Jason.decode!(body, keys: :atoms)}
			{:ok ,%HTTPoison.Response{} = response} -> {:eve_error, response}
			default -> default
		end
	end

	defp check_access_token(character) do
		if character.expires_at <= (DateTime.utc_now |> DateTime.to_unix) do
			refresh_token(character)
		else
			character
		end
	end

	defp refresh_token(character) do
		eve_client_id = Application.get_env(:evemarket_scanner, :eve_client_id)
		eve_client_secret = Application.get_env(:evemarket_scanner, :eve_client_secret)
		base64 = Base.encode64("#{eve_client_id}:#{eve_client_secret}")
		headers = [
			{ "Content-Type", "application/json" },
			{ "Authorization", "Basic " <> base64 }
		]
		body = %{grant_type: "refresh_token", refresh_token: character.refresh_token} |> Jason.encode!
		response = HTTPoison.post!(Urls.token, body, headers).body |> Jason.decode!

		changeset = Character.changeset(character, %{
			access_token: response["access_token"],
			expires_at: add_seconds_to_utc_now(response["expires_in"])
		})

		Repo.update! changeset
	end

	defp add_seconds_to_utc_now(seconds) do
		DateTime.utc_now 
			|> DateTime.to_unix()
			|> Kernel.+(seconds)
	end
end