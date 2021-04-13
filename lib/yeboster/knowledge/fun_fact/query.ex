defmodule Yeboster.Knowledge.FunFact.Query do
  @moduledoc """
  Queries for Funfacts
  """

  import Ecto.Query, warn: false

  alias Yeboster.Repo
  alias Yeboster.Knowledge.{FunFact, Category}

  alias Exmoji.EmojiChar

  def get_id(id) when is_integer(id) do
    with_category()
    |> where(id: ^id)
    |> Repo.one()
  end

  def with_category(query \\ FunFact) do
    query
    |> preload(:category)
  end

  @doc """
  Composable query to get fact with category
  """
  def where_category(query \\ FunFact, category = %Category{}) do
    query
    |> where([fact], fact.category_id == ^category.id)
  end

  @doc """
  Get a random fact and increase show_count
  """
  def get_random_fact(query \\ FunFact) do
    fact =
      query
      |> with_category()
      |> order_by(:show_count)
      |> Repo.get_first()

    case fact do
      %FunFact{} = fact ->
        fact
        |> increase_fact_show_count!()

      nil ->
        %FunFact{}
    end
  end

  @doc """
  Add a reaction emoji to a fun_fact
  """
  def add_reaction!(fact = %FunFact{}, emoji_name) when is_bitstring(emoji_name) do
    case Exmoji.from_short_name(emoji_name) do
      %EmojiChar{short_name: short_name} ->
        fact
        |> FunFact.add_reaction(short_name)
        |> Repo.update!()

      nil ->
        fact
    end
  end

  @doc """
  Remove reaction at given index
  """
  def remove_reaction_at!(fact = %FunFact{}, index) when is_integer(index) do
    fact
    |> FunFact.remove_reaction_at(index)
    |> Repo.update!()
  end

  @doc """
  Remove a reaction emoji to a fun_fact
  """
  def remove_reaction!(fact = %FunFact{}, emoji_name) when is_bitstring(emoji_name) do
    case Exmoji.from_short_name(emoji_name) do
      %EmojiChar{short_name: short_name} ->
        fact
        |> FunFact.remove_reaction(short_name)
        |> Repo.update!()

      nil ->
        fact
    end
  end

  @doc """
  Increase show_count on given fun_fact
  """
  def increase_fact_show_count!(fact = %FunFact{}) do
    FunFact.increase_show_count(fact)
    |> Repo.update!()
  end

  def create_fun_fact(attrs) when is_map(attrs) do
    %FunFact{}
    |> FunFact.changeset(attrs)
    |> Repo.insert()
  end

  def get_fact_with(category = %Category{}) do
    FunFact
    |> where_category(category)
    |> get_random_fact()
  end
end
