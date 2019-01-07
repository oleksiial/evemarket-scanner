defmodule EvemarketScanner.Repo do
  use Ecto.Repo,
    otp_app: :evemarket_scanner,
    adapter: Ecto.Adapters.Postgres

  alias EvemarketScanner.{Repo, Type, Group, Category}

  def create_type(%{} = attrs) do
    case Repo.get Type, attrs.type_id do
      nil -> %Type{} |> Type.changeset(attrs) |> Repo.insert!
      type -> type
    end
  end

  def create_group(%{} = attrs) do
    case Repo.get Group, attrs.group_id do
      nil -> %Group{} |> Group.changeset(attrs) |> Repo.insert!
      group -> group
    end
  end

  def create_category(%{} = attrs) do
    case Repo.get Category, attrs.category_id do
      nil -> %Category{} |> Category.changeset(attrs) |> Repo.insert!
      category -> category
    end
  end
end
