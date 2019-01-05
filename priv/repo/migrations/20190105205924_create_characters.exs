defmodule EvemarketScanner.Repo.Migrations.CreateCharacters do
  use Ecto.Migration

  def change do
    create table(:characters, primary_key: false) do
      add :character_id, :integer, primary_key: true
      add :character_name, :string, null: false
      add :access_token, :string, null: false
      add :expires_at, :integer, null: false
      add :refresh_token, :string, null: false

      timestamps()
    end   
  end
end
