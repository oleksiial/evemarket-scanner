defmodule EvemarketScanner.Repo.Migrations.AddCategoryReferenceToGroups do
  use Ecto.Migration

  def change do
    alter table(:groups) do
      modify :category_id, references(:categories, name: :categories_pkey, column: :category_id), null: false
    end
  end
end
