defmodule RushWeb.RushLive.Controller do
  @moduledoc false
  use RushWeb, :live_view

  alias Rush
  alias RushWeb.StatisticsFilterComponent

  def validate_filter(socket) do
    query_string = socket.assigns.filter

    socket
    |> assign(changeset: StatisticsFilterComponent.validate(%{filter: query_string}))
  end

  def list_players(socket) do
    page_params = get_page_params(socket)

    database =
      case socket.assigns.changeset.valid? do
        true -> Rush.search_players(page_params)
        false -> Rush.get_players_list(page_params)
      end

    socket
    |> assign(players: database.entries, page: database.page_number, total_pages: database.total_pages)
  end

  def update_page_params(socket, params) do
    get_page_params(socket)
    |> Map.merge(params)
  end

  def set_page_params(params \\ %{}) do
    players = []
    filter = params["filter"] || ""
    filter_type = params["filter_type"] || "strict"
    page = params["page"] || 1
    page_size = params["page_size"] || 10
    sort = params["sort"] || "total_yards"
    sort_order = params["sort_order"] || "desc"

    %{players: players, page: page, page_size: page_size,
      filter: filter, filter_type: filter_type, sort: sort, sort_order: sort_order}
  end

  def get_page_params(socket) do
    filter = socket.assigns.filter
    filter_type = socket.assigns.filter_type
    page = socket.assigns.page
    page_size = socket.assigns.page_size
    sort = socket.assigns.sort
    sort_order = socket.assigns.sort_order

    %{page: page, page_size: page_size,
      filter: filter, filter_type: filter_type, sort: sort, sort_order: sort_order}
  end
end
