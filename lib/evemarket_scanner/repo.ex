defmodule EvemarketScanner.Repo do
  use Ecto.Repo,
    otp_app: :evemarket_scanner,
    adapter: Ecto.Adapters.Postgres
end
