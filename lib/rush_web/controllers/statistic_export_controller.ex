defmodule RushWeb.StatisticExportController do
  @moduledoc """
  This module contains the functions for exporting via GET request.
  You can export as CSV at the moment, you might also want to add
  more options.
  """
  use RushWeb, :controller

  alias Rush
  alias Rush.CSV
  alias Rush.Players.Contract
  alias RushWeb.RushLive

  def export_csv(conn, params) do
    parsed_params = RushLive.Controller.set_page_params(params)

    players = Rush.search_players_export(parsed_params)

    return_attached_file(conn, create_csv(players))
  end

  @doc """
  This function declares HTTP readers to send the csv data as a downloadable file.
  """
  defp return_attached_file(conn, data) do
    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header("content-disposition", "attachment; filename=\"nfl_rushing.csv\"")
    |> send_resp(200, data)
  end

  @doc """
  This function declare HTTP readers to show the csv data as a html page, no automatic download.
  """
  defp return_inline(conn, data) do
    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header("content-disposition", "inline")
    |> send_resp(200, data)
  end

  @doc """
  This function is an option to generate a local file with an unique identifier and send the file.
  You'll keep the file in a local folder at priv/static/exports/.
  I was just exploring the possibilities, but you might want to use this to generate a "cache", if the user is
  downloading a csv file without any filters you may want to serve a file that already exists instead
  of fetching the database again.
  Alternatively you might know the most used filters, and may want to serve this same file cached as well.
  For the latter you could name the file as the filters, search if there is a file named as the current filter
  you're holding, if there is not, then you reach the database.
  """
  defp return_file(conn, data) do
    unique_id = "#{Enum.join(Tuple.to_list(conn.remote_ip))}##{DateTime.utc_now |> DateTime.to_unix}"
    file_path = "priv/static/exports/#{unique_id}_nfl_rushing.csv"
    File.write(file_path, data)

    conn
    |> send_file(200, file_path)
  end

  defp create_csv(list_of_maps) do
    [
      get_csv_header |
      list_of_maps_to_list_of_lists(list_of_maps)
    ]
    |> Rush.CSV.encode()
    |> Enum.to_list
    |> to_string
  end

  defp list_of_maps_to_list_of_lists(list_of_maps) do
    list_of_maps
    |> Enum.map(fn player ->
      [
        player.id,
        player.name,
        player.team,
        player.position,
        player.attempts_per_game,
        player.attempts,
        player.total_yards,
        player.average_yards_per_attempt,
        player.yards_per_game,
        player.total_touchdowns,
        Contract.recover_longest_rush_T(player.longest_rush, player.longest_rush_is_touchdown),
        player.total_first_downs,
        player.first_downs_percentage,
        player.rush_20_plus,
        player.rush_40_plus,
        player.fumbles
      ]
    end)
  end

  defp get_csv_header do
    ["Id", "Player", "Team", "Pos", "Att/G", "Att", "Yds", "Avg", "Yds/G", "TD", "Lng", "1st", "1st%", "20+", "40+", "FUM"]
  end
end