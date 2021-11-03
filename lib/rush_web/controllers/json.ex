defmodule RushWeb.Controllers.Json do
  @moduledoc """
  Controllers.Json is a module used to encapsulate the Json decoding function and
  provide an interface to importing a json file.
  """
  use RushWeb, :controller

  def import_json_file(file) do
    File.read!(file)
    |> json_to_map
  end

  def json_to_map(data) do
    Jason.decode!(data)
  end
end
