defmodule Yeboster.Knowledge.FunFact do
  use Ecto.Schema
  import Ecto.Changeset

  alias Yeboster.Knowledge.Category

  schema "fun_facts" do
    field :message, :string
    field :date, :utc_datetime
    field :source, :string
    field :tags, {:array, :string}, default: []

    belongs_to :category, Category

    timestamps()
  end

  @doc false
  def changeset(fun_fact, attrs) do
    fun_fact
    |> cast(attrs, [:message, :date, :source, :tags, :category_id])
    |> validate_required([:message, :tags])
  end
end
