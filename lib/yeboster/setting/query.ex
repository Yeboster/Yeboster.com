defmodule Yeboster.Setting.Query do
  alias Yeboster.{Repo, Setting}

  def get_settings() do
    case Repo.get_first(Setting) do
      settings = %Setting{} ->
        settings

      nil ->
        create_settings!()
    end
  end

  def update_settings!(settings = %Setting{}, attrs) when is_map(attrs) do
    Setting.changeset(settings, attrs)
    |> Repo.update!()
  end

  defp create_settings! do
    Setting.changeset(%Setting{}, %{})
    |> Repo.insert!()
  end
end
