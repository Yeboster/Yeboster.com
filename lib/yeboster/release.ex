defmodule Yeboster.Release do
  @moduledoc """
  Manage release app cycle (Migration, seeds)
  """

  alias Yeboster.Setting.Query, as: Settings
  alias Yeboster.Knowledge.FunFact.Importer

  @app :yeboster

  def seed_if_needed do
    with settings <- Settings.get_settings() do
      unless settings[:seeded] do
        seed()

        Settings.update_settings!(settings, %{seeded: true})
      end
    end
  end

  def migrate do
    ensure_started()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    ensure_started()

    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp repos do
    Application.load(@app)
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp ensure_started do
    Application.ensure_all_started(:ssl)
  end

  defp seed do
    case Application.fetch_env(@app, :app_data_path) do
      {:ok, data_path} ->
        Importer.import_google_facts("#{data_path}/google_facts.json")

      _ ->
        Importer.import_google_facts()
    end
  end
end
