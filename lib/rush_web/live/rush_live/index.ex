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
    query_string = params["filter"]
    filter = %{"filter" => query_string}
    page = params["page"] || 1
    page_size = params["page_size"] || 10

    {:noreply,
    socket
    |> assign(page: page, page_size: page_size)
    |> validate_filter(filter)
    |> list_players(query_string)}
  end

  def handle_event("filter_player", %{"filter" => filter}, socket) do
    query_string = Map.get(filter, "filter")
    params_map = get_page_params(socket)
    params_map = Map.replace!(params_map, :filter, query_string)

    socket = socket
    |> validate_filter(filter)
    |> list_players(query_string)
    |> assign(:filter, query_string)

    {:noreply, push_patch(socket, to: Routes.rush_index_path(socket, :index, params_map))}
  end

  def handle_event("previous_page", _value, socket) do
    new_page = socket.assigns.page - 1
    params_map = get_page_params(socket)
    params_map = Map.replace!(params_map, :page, new_page)

    socket = socket
    |> assign(page: new_page)
    |> list_players(socket.assigns.filter)

    {:noreply, push_patch(socket, to: Routes.rush_index_path(socket, :index, params_map))}
  end

  def handle_event("next_page", _value, socket) do
    new_page = socket.assigns.page + 1
    params_map = get_page_params(socket)
    params_map = Map.replace!(params_map, :page, new_page)

    socket = socket
    |> assign(page: new_page)
    |> list_players(socket.assigns.filter)

    {:noreply, push_patch(socket, to: Routes.rush_index_path(socket, :index, params_map))}
  end

  defp validate_filter(socket) do
    assign(socket, changeset: StatisticsFilterComponent.validate(%{filter: ""}), filter: "")
  end
  defp validate_filter(socket, %{"filter" => query_string} = filter) do
    assign(socket, changeset: StatisticsFilterComponent.validate(filter), filter: query_string)
  end

  defp list_players(socket, filter \\ []) do
    page_params = get_page_params(socket)

    case socket.assigns.changeset.valid? do
      true ->
        database = search_players(filter, page_params)
        assign(socket, players: database.entries, page: database.page_number, total_pages: database.total_pages)
      false ->
        database = get_players_list(page_params)
        assign(socket, players: database.entries, page: database.page_number, total_pages: database.total_pages)
    end
  end

  defp get_players_list(params) do
    Players.get_all(params)
  end

  defp search_players(filter, params) do
    Players.search_player(filter, params)
  end

  defp get_page_params(socket) do
    page = socket.assigns.page
    page_size = socket.assigns.page_size
    filter = socket.assigns.filter

    %{page: page, page_size: page_size, filter: filter}
  end
end
