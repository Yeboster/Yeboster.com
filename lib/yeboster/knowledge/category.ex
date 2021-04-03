defmodule Yeboster.Knowledge.Category do
  use Ecto.Schema
  import Ecto.Changeset

  alias Yeboster.Knowledge.FunFact

  schema "categories" do
    field :description, :string
    field :name, :string

    has_many :fun_facts, FunFact

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :description])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
