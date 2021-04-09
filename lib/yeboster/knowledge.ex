defmodule Yeboster.Knowledge do
  @moduledoc """
  Repository to interacts with multiple models
  """

  import Ecto.Query, warn: false
  alias Yeboster.Repo

  alias Yeboster.Knowledge.FunFact
  alias Yeboster.Knowledge.Category

  alias Exmoji.EmojiChar

  # TODO: What is the best way to manage these queries ?
  #       Create a module for each category ?
  #       Or put composable queries into Schema?

  @doc """
  Composable query to get fact with category
  """
  def with_category(query, category = %Category{}) do
    query
    |> where([fact], fact.category_id == ^category.id)
  end

  @doc """
  Get a random fact and increase show_count
  """
  def get_random_fact(query \\ FunFact) do
    fact =
      query
      |> preload(:category)
      |> order_by(:show_count)
      |> get_first()

    case fact do
      %FunFact{} = fact ->
        increase_fact_show_count(fact)
        fact

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
  def increase_fact_show_count(fact = %FunFact{}) do
    FunFact.increase_show_count(fact)
    |> Repo.update()
  end

  @doc """
  Get all categories
  """
  def get_all_categories() do
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
  Create fun fact
  """
  def create_fun_fact(attrs) when is_map(attrs) do
    %FunFact{}
    |> FunFact.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Create category
  """
  def create_category(attrs) when is_map(attrs) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  def get_first(query) do
    query
    |> limit(1)
    |> Repo.one()
  end
end
