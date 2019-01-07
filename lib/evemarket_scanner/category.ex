defmodule EvemarketScanner.Category do
  use Ecto.Schema

  @primary_key {:category_id, :integer, autogenerate: false}
  schema "categories" do
    field :name, :string
    
    has_many :groups, EvemarketScanner.Group, foreign_key: :category_id
  end

  def changeset(group, params \\ %{}) do
    group
    |> Ecto.Changeset.cast(params, [:category_id, :name])
    |> Ecto.Changeset.validate_required([:category_id, :name])
  end
end