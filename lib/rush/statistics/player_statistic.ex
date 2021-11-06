defmodule Rush.Statistics.PlayerStatistic do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Rush.Players.Player

  schema "player_statistics" do
    field :attempts, :integer
    field :attempts_per_game, :float
    field :total_yards, :integer
    field :average_yards_per_attempt, :float
    field :yards_per_game, :float
    field :total_touchdowns, :integer
    field :longest_rush, :integer
    field :longest_rush_is_touchdown, :boolean
    field :total_first_downs, :integer
    field :first_downs_percentage, :float
    field :rush_20_plus, :integer
    field :rush_40_plus, :integer
    field :fumbles, :integer
    field :player_id, :integer

    belongs_to :players, Player

    timestamps()
  end

  def changeset(struct, attrs, _opts \\ []) do
    fields = get_statistics_contract
    struct
    |> cast(attrs, fields)
    |> validate_required(fields)
  end

  defp get_statistics_contract do
    [
      :attempts, :attempts_per_game, :total_yards, :average_yards_per_attempt, :yards_per_game, :total_touchdowns,
      :longest_rush, :longest_rush_is_touchdown, :total_first_downs,
      :first_downs_percentage, :rush_20_plus, :rush_40_plus, :fumbles, :player_id
    ]
  end
end
