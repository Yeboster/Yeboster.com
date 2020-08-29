defmodule Yeboster.Repo do
  use Ecto.Repo,
    otp_app: :yeboster,
    adapter: Ecto.Adapters.Postgres
end
