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

  def get_all(params) do
    Player
    |> fetch_statistics
    |> Repo.paginate(params)
  end

  def search_player(params) do
    query_string = String.trim(params.filter)
    filter_type = params.filter_type

    Player
    |> filter_player(query_string, filter_type)
    |> fetch_statistics
    |> Repo.paginate(params)
  end

  defp filter_player(query, query_string, "strict") do
    query
    |> where([player], ilike(player.name, ^"#{query_string}%"))
  end
  defp filter_player(query, query_string, "fuzzy") do
    start_character = String.slice(query_string, 0..1)

    query
    |> where([player], ilike(player.name, ^"#{start_character}%"))
    |> where([player], fragment("SIMILARITY(?, ?) > 0.2", player.name, ^query_string))
    |> order_by([player], fragment("LEVENSHTEIN(?, ?)", player.name, ^query_string))
  end

  defp fetch_statistics(query) do
    from(
      player in query,
      right_join: statistic in PlayerStatistic,
      on: statistic.player_id == player.id,
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

  defp insert_player(player) do
    player_changeset = Player.changeset(%Player{}, player)

    Multi.new()
    |> Multi.insert(:players, player_changeset)
    |> Multi.insert(:player_statistics, fn %{players: %Player{id: player_id}} ->
      PlayerStatistic.changeset(%PlayerStatistic{}, Map.put(player, "player_id", player_id))
    end)
  end
end
