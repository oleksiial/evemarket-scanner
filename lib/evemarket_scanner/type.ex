defmodule EvemarketScanner.Type do
  use Ecto.Schema

  @primary_key {:type_id, :integer, autogenerate: false}
  schema "types" do
    field :name, :string
		field :market_group_id, :integer
    
    belongs_to :group, EvemarketScanner.Group, references: :group_id
  end

  def changeset(type, params \\ %{}) do
    type
    |> Ecto.Changeset.cast(params, [:type_id, :name, :market_group_id, :group_id])
    |> Ecto.Changeset.validate_required([:type_id, :name, :group_id])
  end
end