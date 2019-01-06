defmodule EvemarketScanner.Character do
  use Ecto.Schema
  @timestamps_opts [type: :utc_datetime]

  @primary_key {:character_id, :integer, autogenerate: false}
  schema "characters" do
    field :character_name, :string
		field :access_token, :string
		field :expires_at, :integer
    field :refresh_token, :string
    field :buy_fee, :float, default: 0.003
    field :sell_fee, :float, default: 0.025
    field :sell_tax, :float, default: 0.010

    timestamps()
  end

  def changeset(character, params \\ %{}) do
    character
    |> Ecto.Changeset.cast(params, [:buy_fee, :sell_fee, :sell_tax, :character_id, :character_name, :access_token, :expires_at, :refresh_token])
    |> Ecto.Changeset.validate_required([:character_id, :character_name, :access_token, :expires_at, :refresh_token])
  end
end