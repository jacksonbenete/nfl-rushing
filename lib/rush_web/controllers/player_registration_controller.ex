defmodule RushWeb.PlayerRegistrationController do
  @moduledoc """
  The PlayerRegistrationController is responsible to receive a decoded json map
  and apply a contract to validate the structure.
  """
  use RushWeb, :controller

  alias Rush.Players
  alias Rush.Players.Contract

  def insert_player(player) do
    Players.persist_player(player)
  end

  def create_player_from_json(data) do
    Contract.player_from_json(data)
  end

  def create_player_from_map(map) do
    Contract.player_from_map(map)
  end
end
