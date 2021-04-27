defmodule Yeboster.Knowledge.Category.Query do
  @moduledoc """
  Queries for Category
  """
  alias Yeboster.Repo

  alias Yeboster.Knowledge.Category

  @doc """
  Get all categories
  """
  def all() do
    Category
    |> Repo.all()
  end

  @doc """
  Find by or create category
  """
  def find_by_category_or_create(attrs) when is_map(attrs) do
    case Category |> Repo.get_by(attrs) do
      %Category{} = category ->
        {:ok, category}

      nil ->
        create_category(attrs)
    end
  end

  @doc """
  Create category
  """
  def create_category(attrs) when is_map(attrs) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end
end
