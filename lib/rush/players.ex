defmodule Rush.Players do
  @moduledoc """
  The Player context includes Player Use Cases.
  Use Cases interacts with domains.
  """

  alias Ecto.Multi
  alias Rush.Players.Player
  alias Rush.Repo
  alias Rush.Statistics.PlayerStatistic

  def persist_player(player) do
    player
    |> insert_player
    |> Repo.transaction()
  end

  def insert_player(player) do
    player_changeset = Player.changeset(%Player{}, player)

    Multi.new()
    |> Multi.insert(:players, player_changeset)
    |> Multi.insert(:player_statistics, fn %{players: %Player{id: player_id}} ->
      PlayerStatistic.changeset(%PlayerStatistic{}, Map.put(player, "player_id", player_id))
    end)
  end

end
