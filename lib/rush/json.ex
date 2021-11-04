defmodule Rush.Json do
  @moduledoc """
  Rush.Json is a module used to encapsulate the Json decoding function and
  provide an interface to importing a json file.
  """

  def import_json_file(file) do
    File.read!(file)
    |> json_to_map
  end

  def json_to_map(data) do
    Jason.decode!(data)
  end
end
