defmodule Yeboster.Repo do
  use Ecto.Repo,
    otp_app: :yeboster,
    adapter: Ecto.Adapters.Postgres

  import Ecto.Query, only: [limit: 2]

  alias Yeboster.Repo

  def get_first(query) do
    query
    |> limit(1)
    |> Repo.one()
  end

  # Helper methods for error handling

  def changeset_errors_to_string(list) when is_list(list) do
    Enum.map(list, &changeset_error_to_string/1)
  end

  def changeset_error_to_string({field, {error, details}})
      when is_atom(field) and is_bitstring(error) and is_list(details) do
    "Field '#{field}' #{error}"
  end
end
