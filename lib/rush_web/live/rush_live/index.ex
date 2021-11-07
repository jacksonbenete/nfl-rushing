defmodule RushWeb.RushLive.Index do
  @moduledoc false
  use RushWeb, :live_view

  alias RushWeb.RushLive.Controller

  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> assign(Controller.set_page_params)
      |> Controller.validate_filter
    }
  end

  def handle_params(params, _, socket) do
    page_params = Controller.set_page_params(params)

    {
      :noreply,
      socket
      |> assign(page_params)
      |> Controller.validate_filter
      |> Controller.list_players
    }
  end

  def handle_event("filter_player", %{"input" => %{"filter" => query_string}}, socket) do
    page_params = Controller.update_page_params(socket, %{filter: query_string})

    {
      :noreply,
      socket
      |> push_patch(to: Routes.rush_index_path(socket, :index, page_params))
    }
  end

  def handle_event("previous_page", _value, socket) do
    new_page = socket.assigns.page - 1
    page_params = Controller.update_page_params(socket, %{page: new_page})

    {
      :noreply,
      socket
      |> push_patch(to: Routes.rush_index_path(socket, :index, page_params))
    }
  end

  def handle_event("next_page", _value, socket) do
    new_page = socket.assigns.page + 1
    page_params = Controller.update_page_params(socket, %{page: new_page})

    {
      :noreply,
      socket
      |> push_patch(to: Routes.rush_index_path(socket, :index, page_params))
    }
  end

  def handle_event("sort_statistics", %{"sort" => sort, "sort_order" => sort_order}, socket) do
    page_params = Controller.update_page_params(socket, %{sort: sort, sort_order: sort_order})

    {
      :noreply,
      socket
      |> push_patch(to: Routes.rush_index_path(socket, :index, page_params))
    }
  end
end
