defmodule EvemarketScanner.Repo do
  use Ecto.Repo,
    otp_app: :evemarket_scanner,
    adapter: Ecto.Adapters.Postgres

  def insert_types(type_ids) do
    types_info = EvemarketScanner.types_info(type_ids)
    Enum.each(types_info, fn type ->
      type_l = type |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)
      changeset = struct EvemarketScanner.Type, type_l
      EvemarketScanner.Repo.insert! changeset
    end)
  end
end
