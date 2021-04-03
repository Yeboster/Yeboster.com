defmodule Yeboster.Knowledge do
  @moduledoc """
  Repository to interacts with multiple models
  """

  alias Yeboster.Repo
  alias Yeboster.Knowledge.FunFact
  alias Yeboster.Knowledge.Category

  def get_category_by(attrs) do
    Repo.get_by(Category, attrs)
  end

  def find_by_category_or_create(attrs) when is_map(attrs) do
    case get_category_by(attrs) do
      %Category{} = category ->
        {:ok, category}

      nil ->
        create_category(attrs)
    end
  end

  def create_fun_facts(attrs) when is_map(attrs) do
    %FunFact{}
    |> FunFact.changeset(attrs)
    |> Repo.insert()
  end

  def create_category(attrs) when is_map(attrs) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end
end
