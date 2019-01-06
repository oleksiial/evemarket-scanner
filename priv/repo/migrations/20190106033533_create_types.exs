defmodule EvemarketScanner.Repo.Migrations.CreateTypes do
  use Ecto.Migration

  def change do
    create table(:types, primary_key: false) do
      add :type_id, :integer, primary_key: true
      add :name, :string, null: false
		  add :market_group_id, :integer
		  add :group_id, :integer, null: false
    end 
  end
end
