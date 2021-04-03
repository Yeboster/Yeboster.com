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

    belongs_to(:category, Category)

    timestamps()
  end

  @doc false
  def changeset(fun_fact, attrs) do
    fun_fact
    |> cast(attrs, [:message, :date, :source, :tags, :category_id])
    |> validate_required([:message, :tags])
  end

  def increase_show_count(%FunFact{} = fact) do
    updated_count = fact.show_count + 1
    change(fact, %{show_count: updated_count})
  end
end
