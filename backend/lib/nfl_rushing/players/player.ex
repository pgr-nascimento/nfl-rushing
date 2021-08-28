defmodule NflRushing.Players.Player do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [
    :name,
    :team_acronym,
    :position,
    :attempts,
    :attempts_per_game_average,
    :total_yards,
    :average_yards_per_attempt,
    :yards_per_game,
    :total_touchdowns,
    :longest_rush,
    :first_downs,
    :first_down_percentage,
    :twenty_plus_yards,
    :forty_plus_yards,
    :total_fumbles
  ]

  @derive {Jason.Encoder, only: @required_fields}

  schema "players" do
    field :attempts, :integer
    field :attempts_per_game_average, :float
    field :average_yards_per_attempt, :float
    field :first_down_percentage, :float
    field :first_downs, :integer
    field :forty_plus_yards, :integer
    field :longest_rush, :integer
    field :name, :string
    field :position, :string
    field :team_acronym, :string
    field :total_fumbles, :integer
    field :total_touchdowns, :integer
    field :total_yards, :float
    field :twenty_plus_yards, :integer
    field :yards_per_game, :float

    timestamps()
  end

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, @required_fields)
    |> validate_required([@required_fields])
  end
end
