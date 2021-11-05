defmodule RushWeb.RushLive.Index do
  @moduledoc false
  use RushWeb, :live_view

  alias Rush.Players
  alias RushWeb.StatisticsFilterComponent

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> validate_filter
     |> assign(players: [])}
  end

  def handle_params(params, _, socket) do
    filter = %{"filter" => params["filter"]}

    {:noreply,
    socket
    |> validate_filter(filter)
    |> list_players(filter)}
  end

  def handle_event("filter_player", %{"filter" => filter}, socket) do
    query_string = Map.get(filter, "filter")

    socket = socket
    |> validate_filter(filter)
    |> list_players(query_string)
    |> assign(:filter, query_string)

    {:noreply, socket}
  end

  defp validate_filter(socket) do
    assign(socket, changeset: StatisticsFilterComponent.validate(%{filter: ""}), filter: "")
  end
  defp validate_filter(socket, %{"filter" => query_string} = filter) do
    assign(socket, changeset: StatisticsFilterComponent.validate(filter), filter: query_string)
  end

  defp list_players(socket, filter \\ []) do
    case socket.assigns.changeset.valid? do
      true -> assign(socket, :players, search_players(filter))
      false -> assign(socket, :players, get_players_list())
    end
  end

  defp get_players_list do
    Players.get_all
  end

  defp search_players(filter) do
    Players.search_player(filter)
  end
end
