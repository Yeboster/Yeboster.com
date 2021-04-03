defmodule Yeboster.Knowledge do
  @moduledoc """
  Repository to interacts with multiple models
  """

  import Ecto.Query, warn: false

  alias Yeboster.Repo
  alias Yeboster.Knowledge.FunFact
  alias Yeboster.Knowledge.Category

  def get_random_fact do
    fact =
      FunFact
      |> order_by(:show_count)
      |> limit(1)
      |> preload(:category)
      |> Repo.one()

    case fact do
      %FunFact{} = fact ->
        increase_fact_show_count(fact)
        fact

      nil ->
        %FunFact{}
    end
  end

  def increase_fact_show_count(%FunFact{} = fact) do
    FunFact.increase_show_count(fact)
    |> Repo.update()
  end

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
