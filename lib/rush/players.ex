defmodule Rush.Players do
  @moduledoc """
  The Player context includes Player Use Cases.
  Use Cases interacts with domains.
  """

  import Ecto.Query, warn: false

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

  def get_all do
    valid_schema
    |> Repo.all
  end

  def search_player(query_string) do
     start_character = String.slice(query_string, 0..1)

    from(
      player in Player,
      where: ilike(player.name, ^"#{start_character}%"),
      where: fragment("SIMILARITY(?, ?) > 0", player.name, ^query_string),
      order_by: fragment("LEVENSHTEIN(?, ?)", player.name, ^query_string),
      right_join: statistic in PlayerStatistic,
      on: statistic.player_id == player.id,
      limit: 10,
      select_merge: %{
        attempts: statistic.attempts,
        attempts_per_game: statistic.attempts_per_game,
        total_yards: statistic.total_yards,
        average_yards_per_attempt: statistic.average_yards_per_attempt,
        yards_per_game: statistic.yards_per_game,
        total_touchdowns: statistic.total_touchdowns,
        longest_rush: statistic.longest_rush,
        longest_rush_is_touchdown: statistic.longest_rush_is_touchdown,
        total_first_downs: statistic.total_first_downs,
        first_downs_percentage: statistic.first_downs_percentage,
        rush_20_plus: statistic.rush_20_plus,
        rush_40_plus: statistic.rush_40_plus,
        fumbles: statistic.fumbles
      }
    )
    |> Repo.all()
  end

  # TODO: remover artificial limit
  defp valid_schema do
    from(
      player in Player,
      right_join: statistic in PlayerStatistic,
      on: statistic.player_id == player.id,
      limit: 10,
      select_merge: %{
        attempts: statistic.attempts,
        attempts_per_game: statistic.attempts_per_game,
        total_yards: statistic.total_yards,
        average_yards_per_attempt: statistic.average_yards_per_attempt,
        yards_per_game: statistic.yards_per_game,
        total_touchdowns: statistic.total_touchdowns,
        longest_rush: statistic.longest_rush,
        longest_rush_is_touchdown: statistic.longest_rush_is_touchdown,
        total_first_downs: statistic.total_first_downs,
        first_downs_percentage: statistic.first_downs_percentage,
        rush_20_plus: statistic.rush_20_plus,
        rush_40_plus: statistic.rush_40_plus,
        fumbles: statistic.fumbles
      }
    )
  end

end
