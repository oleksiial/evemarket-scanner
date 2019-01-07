defmodule EvemarketScanner.Repo.Migrations.AddGroupReferenceToTypes do
  use Ecto.Migration

  def change do
    alter table(:types) do
      modify :group_id, references(:groups, name: :groups_pkey, column: :group_id), null: false
    end
  end
end
