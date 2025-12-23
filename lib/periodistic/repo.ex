defmodule Periodistic.Repo do
  use Ecto.Repo,
    otp_app: :periodistic,
    adapter: Ecto.Adapters.Postgres
end
