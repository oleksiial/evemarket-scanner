defmodule EvemarketScanner.Repo.Migrations.CreateGroups do
  use Ecto.Migration

  def change do
    create table(:groups, primary_key: false) do
      add :group_id, :integer, primary_key: true
      add :name, :string, null: false
      add :category_id, :integer, null: false
    end
  end
end
