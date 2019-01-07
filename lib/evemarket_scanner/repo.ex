defmodule EvemarketScanner.Repo do
  use Ecto.Repo,
    otp_app: :evemarket_scanner,
    adapter: Ecto.Adapters.Postgres

  def create_type(%{} = attrs) do
    attrs = attrs |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)
    changeset = struct EvemarketScanner.Type, attrs
    EvemarketScanner.Repo.insert! changeset
  end
end
