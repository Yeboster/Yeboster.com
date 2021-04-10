defmodule Yeboster.Repo.Migrations.AddReactionsToFunFacts do
  use Ecto.Migration

  def change do
    alter table(:fun_facts) do
      add :reactions, {:array, :string}, default: []
    end
  end
end
