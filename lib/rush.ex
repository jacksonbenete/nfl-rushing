defmodule Rush do
  @moduledoc """
  Rush keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias Rush.Players

  def get_players_list(params) do
    Players.get_all(params)
    |> Players.pagination(params)
  end

  def search_players(params) do
    Players.search_player(params)
    |> Players.pagination(params)
  end

  def search_players_export(params) do
    Players.search_player(params)
    |> Players.all
  end
end
