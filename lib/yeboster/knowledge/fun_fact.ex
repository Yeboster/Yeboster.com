defmodule Yeboster.Knowledge.FunFact do
  use Ecto.Schema
  import Ecto.Changeset

  schema "fun_facts" do
    field :message, :string
    field :source, :string
    field :tags, {:array, :string}
    field :category_id, :id

    timestamps()
  end

  @doc false
  def changeset(fun_fact, attrs) do
    fun_fact
    |> cast(attrs, [:message, :source, :tags])
    |> validate_required([:message, :tags])
  end
end
