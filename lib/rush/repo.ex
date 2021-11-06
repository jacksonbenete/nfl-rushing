defmodule Rush.Repo do
  use Ecto.Repo,
    otp_app: :rush,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 10
end
