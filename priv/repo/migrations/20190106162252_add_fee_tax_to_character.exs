defmodule EvemarketScanner.Repo.Migrations.AddFeeTaxToCharacter do
  use Ecto.Migration

  def change do
    alter table(:characters) do
      add :buy_fee, :float, default: 0.003
      add :sell_fee, :float, default: 0.025
      add :sell_tax, :float, default: 0.010
    end
  end
end
