defmodule NflRushing.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :attempts, :integer
      add :attempts_per_game_average, :float
      add :average_yards_per_attempt, :float
      add :first_downs, :integer
      add :first_down_percentage, :float
      add :forty_plus_yards, :integer
      add :longest_rush, :integer
      add :name, :string
      add :position, :string
      add :team_acronym, :string
      add :total_fumbles, :integer
      add :total_touchdowns, :integer
      add :total_yards, :float
      add :twenty_plus_yards, :integer
      add :yards_per_game, :float

      timestamps()
    end

  end
end
