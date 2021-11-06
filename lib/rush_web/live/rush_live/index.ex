defmodule RushWeb.RushLive.Index do
  @moduledoc false
  use RushWeb, :live_view

  alias Rush
  alias RushWeb.StatisticsFilterComponent

  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> assign(set_page_params)
      |> validate_filter
    }
  end

  def handle_params(params, _, socket) do
    page_params = set_page_params(params)

    {
      :noreply,
      socket
      |> assign(page_params)
      |> validate_filter
      |> list_players
    }
  end

  def handle_event("filter_player", %{"input" => %{"filter" => query_string}}, socket) do
    page_params = update_page_params(socket, :filter, query_string)

    {
      :noreply,
      socket
      |> push_patch(to: Routes.rush_index_path(socket, :index, page_params))
    }
  end

  def handle_event("previous_page", _value, socket) do
    new_page = socket.assigns.page - 1
    page_params = update_page_params(socket, :page, new_page)

    {
      :noreply,
      socket
      |> push_patch(to: Routes.rush_index_path(socket, :index, page_params))
    }
  end

  def handle_event("next_page", _value, socket) do
    new_page = socket.assigns.page + 1
    page_params = update_page_params(socket, :page, new_page)

    {
      :noreply,
      socket
      |> push_patch(to: Routes.rush_index_path(socket, :index, page_params))
    }
  end

  defp validate_filter(socket) do
    query_string = socket.assigns.filter

    socket
    |> assign(changeset: StatisticsFilterComponent.validate(%{filter: query_string}))
  end

  defp list_players(socket) do
    page_params = get_page_params(socket)

    database =
    case socket.assigns.changeset.valid? do
      true -> Rush.search_players(page_params)
      false -> Rush.get_players_list(page_params)
    end

    socket
    |> assign(players: database.entries, page: database.page_number, total_pages: database.total_pages)
  end

  defp update_page_params(socket, field, value) do
    get_page_params(socket)
    |> Map.replace!(field, value)
  end

  defp set_page_params(params \\ %{}) do
    players = []
    filter = params["filter"] || ""
    filter_type = params["filter_type"] || "strict"
    page = params["page"] || 1
    page_size = params["page_size"] || 10

    %{players: players, page: page, page_size: page_size, filter: filter, filter_type: filter_type}
  end

  defp get_page_params(socket) do
    filter = socket.assigns.filter
    filter_type = socket.assigns.filter_type
    page = socket.assigns.page
    page_size = socket.assigns.page_size

    %{page: page, page_size: page_size, filter: filter, filter_type: filter_type}
  end
end
