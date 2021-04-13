defmodule Yeboster.Knowledge.FunFact do
  use Ecto.Schema
  import Ecto.Changeset

  alias Yeboster.Knowledge.Category
  alias Yeboster.Knowledge.FunFact

  schema "fun_facts" do
    field(:message, :string)
    field(:date, :utc_datetime)
    field(:source, :string)
    field(:tags, {:array, :string}, default: [])
    field(:show_count, :integer, default: 0)
    field(:reactions, {:array, :string}, default: [])

    belongs_to(:category, Category)

    timestamps()
  end

  @doc false
  def changeset(fun_fact, attrs) do
    fun_fact
    |> cast(attrs, [:message, :date, :source, :tags, :category_id])
    |> validate_required([:message, :tags])
  end

  def increase_show_count(fact = %FunFact{}) do
    updated_count = fact.show_count + 1

    fact
    |> change(%{show_count: updated_count})
  end

  def add_reaction(fact = %FunFact{}, reaction) when is_bitstring(reaction) do
    updated_reactions = fact.reactions ++ [reaction]

    fact
    |> change(%{reactions: updated_reactions})
  end

  def remove_reaction(fact = %FunFact{}, reaction) when is_bitstring(reaction) do
    fact.reactions
    |> List.delete(reaction)
    |> change_reactions(fact)
  end

  def remove_reaction_at(fact = %FunFact{}, index) when is_integer(index) do
    fact.reactions
    |> List.delete_at(index)
    |> change_reactions(fact)
  end

  defp change_reactions(reactions, fact = %FunFact{}) when is_list(reactions) do
    fact
    |> change(%{reactions: reactions})
  end
end
