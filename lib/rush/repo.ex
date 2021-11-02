defmodule Rush.Repo do
  use Ecto.Repo,
    otp_app: :rush,
    adapter: Ecto.Adapters.Postgres
end
