defmodule Rush.Players.Contract do
  @moduledoc """
  This module implements an anti-corruption layer.
  It validates and parses data from different sources (json, map, etc)
  and maps it to a valid Player (Rush.Players.Player).
  """

  alias Rush.Json
  alias Rush.Players.Player
  alias Rush.Statistics.PlayerStatistic

  def player_from_json(data) do
    data
    |> Json.json_to_map
    |> player_from_map
  end

  def player_from_map(map) do
    map
    |> apply_contract(get_contract)
    |> validate_player
  end

  @doc """
  This function parses the Lng and Yds attributes which are the only fields that can have values as
  bitstrings instead of and integer from the provided source.
  """
  defp validate_player(%{} = map) do
    player = map
    |> parse_longest_rush()
    |> parse_total_yards()
  end

  @doc """
  Merge fields translating one map into a new one.
  """
  defp apply_contract(map, contract) do
    map
    |> Enum.map(fn x -> merge_fields(contract, x) end)
    |> Map.new()
  end

  @doc """
  Recombine values of each field using a contract as a base.

  E.g. If contract is %{"Yds" => "total_yards"} it will
  turns %{"Yds" => 100} into %{"total_yards" => 100}.
  """
  defp merge_fields(contract, field) do
    {
      Map.get(contract, elem(field, 0)),
      elem(field, 1)
    }
  end

  @doc """
  This method divides the "Lng" attribute into two attributes,
  "longest_rush" and "longest_rush_is_touchdown".

  The "Lng" attribute arrives as a string or an integer.
  It can have a "T" character in the end of the String meaning the longest_rush
  is a touchdown.
  The string is converted to integer, and if a touchdown occurred it will be signaled
  by a new boolean attribute.
  """
  defp parse_longest_rush(map) when map == %{}, do: map
  defp parse_longest_rush(%{"longest_rush" => longest_rush} = map) when is_bitstring(longest_rush) do
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
  defp parse_longest_rush(%{"longest_rush" => longest_rush} = map) when is_integer(longest_rush) do
    map
    |> Map.put("longest_rush_is_touchdown", :false)
  end

  def recover_longest_rush_T(%{longest_rush: longest_rush, longest_rush_is_touchdown: longest_rush_is_touchdown} = map) do
    case longest_rush_is_touchdown do
      true -> map |> Map.replace!(:longest_rush, "#{Integer.to_string(longest_rush)}T")
      _ -> map |> Map.replace!(:longest_rush, Integer.to_string(longest_rush))
    end
  end
  def recover_longest_rush_T(longest_rush, longest_rush_is_touchdown) do
    case longest_rush_is_touchdown do
      true -> "#{Integer.to_string(longest_rush)}T"
      _ -> Integer.to_string(longest_rush)
    end
  end

  @doc """
  This method receives the "total_yards" attribute (Yds) and parses its value.
  The value can arrive as a String or as Integer, if it's a String removes any
  commas and parse to Integer.
  """
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
