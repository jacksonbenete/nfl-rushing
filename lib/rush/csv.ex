defmodule Rush.CSV do
  @moduledoc """
  Just a façade for the CSV extension.
  """

  def encode(list_of_lists) do
    CSV.encode(list_of_lists)
  end
end