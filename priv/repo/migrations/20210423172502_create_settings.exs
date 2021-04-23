defmodule Yeboster.Repo.Migrations.CreateSettings do
  use Ecto.Migration

  def change do
    create table(:settings) do
      add :data, :map, default: %{}

      # GIN index is not needed since there is only one setting
      timestamps()
    end
  end
end
