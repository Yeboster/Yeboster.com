defmodule Yeboster.Repo.Migrations.CreateFunFacts do
  use Ecto.Migration

  def change do
    create table(:fun_facts) do
      add :message, :text
      add :source, :string
      add :tags, {:array, :string}
      add :category_id, references(:categories, on_delete: :nothing)

      timestamps()
    end

    create index(:fun_facts, [:category_id])
  end
end
