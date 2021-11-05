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

  def find_type(data, type_function) do
    Enum.zip(data)
    |> Enum.map(fn x -> Tuple.to_list(x) end)
    |> Enum.map(fn list -> Enum.filter(list, fn tuple -> type_function.(elem(tuple, 1)) end) end)
    |> Enum.filter(fn list -> list != [] end)
    |> Enum.map(fn [head | tail] -> head end)
    |> Enum.map(fn tuple -> elem(tuple, 0) end)
  end

  def explore_field(data, field) do
    Enum.zip(data)
    |> Enum.map(fn x -> Tuple.to_list(x) end)
    |> Enum.map(fn list -> Enum.filter(list, fn tuple -> elem(tuple, 0) == field end) end)
    |> Enum.filter(fn list -> list != [] end)
  end
end
