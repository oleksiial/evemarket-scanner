defmodule EvemarketScanner.Group do
  use Ecto.Schema

  @primary_key {:group_id, :integer, autogenerate: false}
  schema "groups" do
    field :name, :string
    field :category_id, :integer
    
    has_many :types, EvemarketScanner.Type, foreign_key: :group_id
  end

  def changeset(group, params \\ %{}) do
    group
    |> Ecto.Changeset.cast(params, [:category_id, :name, :group_id])
    |> Ecto.Changeset.validate_required([:category_id, :name, :group_id])
  end
end