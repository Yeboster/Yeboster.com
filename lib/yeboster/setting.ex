defmodule Yeboster.Setting do
  use Ecto.Schema
  import Ecto.Changeset

  schema "settings" do
    field :data, :map

    timestamps()
  end

  @doc false
  def changeset(setting, attrs) do
    setting
    |> cast(attrs, [:data])
    |> validate_required([:data])
  end
end
