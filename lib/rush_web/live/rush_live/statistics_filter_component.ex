defmodule RushWeb.StatisticsFilterComponent do
  @moduledoc """
  This module is here not only because we want to use a live component but
  we need a changeset for our "fake" form.
  The filter_player input works inside a form, so this changeset validates
  the input received, such as filtering the query only if at least
  three characters have been typed.
  """
  use RushWeb, :live_component

  alias Ecto.Changeset

  @types %{filter: :string}

  def validate(params) do
    {%{}, @types}
    |> Changeset.cast(params, Map.keys(@types))
    |> Changeset.validate_required([:filter])
    |> Changeset.update_change(:filter, &String.trim/1)
    |> Changeset.validate_length(:filter, min: 3)
    |> Changeset.validate_format(:filter, ~r/[A-Za-z0-9\ ]/)
    |> Map.put(:action, :validate)
  end
end
