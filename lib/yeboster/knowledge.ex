defmodule Yeboster.Knowledge do
  @moduledoc """
  Repository to interacts with multiple models
  """

  import Ecto.Query, warn: false
  alias Yeboster.Repo

  alias Yeboster.Knowledge.FunFact
  alias Yeboster.Knowledge.Category

  alias Exmoji.EmojiChar

  @doc """
  Get a random fact and increase show_count
  """
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
  Get category by attributes
  """
  def get_category_by(attrs) do
    Repo.get_by(Category, attrs)
  end

  @doc """
  Find by or create category
  """
  def find_by_category_or_create(attrs) when is_map(attrs) do
    case get_category_by(attrs) do
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
end
