defmodule EvemarketScanner.Repo do
  use Ecto.Repo,
    otp_app: :evemarket_scanner,
    adapter: Ecto.Adapters.Postgres

  def create_type(%{} = attrs) do
    changeset = EvemarketScanner.Type.changeset(%EvemarketScanner.Type{}, attrs)
    EvemarketScanner.Repo.insert! changeset
  end

  def create_group(%{} = attrs) do
    changeset = EvemarketScanner.Group.changeset(%EvemarketScanner.Group{}, attrs)
    EvemarketScanner.Repo.insert! changeset
  end
end
