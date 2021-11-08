defmodule Rush.DataAnalysis do
  @moduledoc """
  Rush.DataAnalysis is responsible to facilitate the analysis of data.
  The algorithm will work on the structure provided by rushing.json, but might also work
  in other lists of objects (json) or list of maps (elixir).
  """
  alias Rush.Json

  def data_collection_from_file(file) do
    data = Json.import_json_file(file)
  end

  @doc """
  This functions searches for a type in the provided json data.

  ### Examples

      iex> data = Rush.Json.import_json_file("test/test_data.json")
      iex> Rush.DataAnalysis.find_type(data, &is_bitstring/1)
      ["Lng", "Player", "Pos", "Team", "Yds"]

  1. Transform the list of maps into a list of tuples using zip, each tuple is a collection of attributes
  2. It's hard to iterate on tuples, so transform each tuple into a list, you'll have a list of lists
  3. Filter each sublist to delete everything that isn't a bitstring
  4. Remove the empty sublists
  5. Keep the head of each sublist
  6. Collect the name of each field that contains at least one bitstring as a value
  """
  def find_type(data, type_function) do
    Enum.zip(data)
    |> Enum.map(fn x -> Tuple.to_list(x) end)
    |> Enum.map(fn list -> Enum.filter(list, fn tuple -> type_function.(elem(tuple, 1)) end) end)
    |> Enum.filter(fn list -> list != [] end)
    |> Enum.map(fn [head | tail] -> head end)
    |> Enum.map(fn tuple -> elem(tuple, 0) end)
  end

  @doc """
  This function extracts a specific field from the entire lists.

  ### Examples

      iex(3)> Rush.DataAnalysis.explore_field(data, "Avg")
      [{"Avg", {"Avg", 1}, {"Avg", 2}, {"Avg", 0.5}, ...]

  1. Transform the list of maps into a list of tuples using zip, each tuple is a collection of attributes
  2. It's hard to iterate on tuples, so transform each tuple into a list, you'll have a list of lists
  3. Filter each sublist for the field provided
  4. Remove the empty sublists
  """
  def explore_field(data, field) do
    Enum.zip(data)
    |> Enum.map(fn x -> Tuple.to_list(x) end)
    |> Enum.map(fn list -> Enum.filter(list, fn tuple -> elem(tuple, 0) == field end) end)
    |> Enum.filter(fn list -> list != [] end)
  end
end
