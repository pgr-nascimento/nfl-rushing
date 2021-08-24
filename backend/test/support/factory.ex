defmodule NflRushing.Factory do
  use ExMachina.Ecto, repo: NflRushing.Repo

  def player_factory do
    %NflRushing.Player{
      attempts: 2,
      attempts_per_game_average: 2.0,
      average_yards_per_attempt: 3.0,
      first_downs: 1,
      first_down_percentage: 2.2,
      forty_plus_yards: 2,
      longest_rush: 7,
      name: "Joe Banyard",
      position: "RB",
      team_acronym: "JAX",
      total_fumbles: 3,
      total_touchdowns: 4,
      total_yards: 3.0,
      twenty_plus_yards: 5,
      yards_per_game: 7.0
    }
  end
end
