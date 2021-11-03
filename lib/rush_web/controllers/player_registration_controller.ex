defmodule RushWeb.PlayerRegistrationController do
  @moduledoc """
  The PlayerRegistrationController is responsible to receive a decoded json map
  and apply a contract to validate the structure.
  """
  use RushWeb, :controller

  """
  This function applies the contract acting like an anti-corruption layer,
  then it parses the Lng and Yds attributes which are the only fields that can have values as
  bitstrings instead of and integer from the provided source.
  """
  def map_to_player(%{} = map) do
    map
    |> apply_contract()
    |> parse_longest_rush()
    |> parse_total_yards()
  end

  defp apply_contract(map) do
    contract = get_contract

    map
    |> Enum.map(fn x -> merge_fields(contract, x) end)
    |> Map.new()
  end

  defp merge_fields(contract, field) do
    {
      Map.get(contract, elem(field, 0)),
      elem(field, 1)
    }
  end

  defp parse_longest_rush(map) when map == %{}, do: map
  defp parse_longest_rush(map) do
    longest_rush = Map.get(map, "longest_rush")
    last_character = String.at(longest_rush, -1)

    case last_character == "T" do
      true ->
        map
        |> Map.replace!("longest_rush", String.to_integer(String.slice(longest_rush, 0..-2)))
        |> Map.put("longest_rush_is_touchdown", :true)
      false ->
        map
        |> Map.replace!("longest_rush", String.to_integer(longest_rush))
        |> Map.put("longest_rush_is_touchdown", :false)
    end
  end

  defp parse_total_yards(map) when map == %{}, do: map
  defp parse_total_yards(map) do
    total_yards = Map.get(map, "total_yards")

    case is_bitstring(total_yards) do
      false -> map
      true ->
        total_yards = total_yards
        |> String.replace(",", "")
        |> String.to_integer()

        map
        |> Map.replace!("total_yards", total_yards)
    end
  end

  defp get_contract do
    %{
    "Player" => "name",
    "Team" => "team",
    "Pos" => "position",
    "Att" => "attempts",
    "Att/G" => "attempts_per_game",
    "Yds" => "total_yards",
    "Avg" => "average_yards_per_attempt",
    "Yds/G" => "yards_per_game",
    "TD" => "total_touchdowns",
    "Lng" => "longest_rush",
    "1st" => "total_first_downs",
    "1st%" => "first_downs_percentage",
    "20+" => "rush_20_plus",
    "40+" => "rush_40_plus",
    "FUM" => "fumbles"
    }
  end
end
