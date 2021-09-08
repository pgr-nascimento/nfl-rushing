defmodule NflRushing.Players.Export do
  alias NflRushing.Players.Player

  def build_player(%Player{} = player) do
    %{
      "Player" => player.name,
      "Team" => player.team_acronym,
      "Pos" => player.position,
      "Att/G" => player.attempts_per_game_average,
      "Att" => player.attempts,
      "Yds" => player.total_yards,
      "Avg" => player.average_yards_per_attempt,
      "Yds/G" => player.yards_per_game,
      "TD" => player.total_touchdowns,
      "Lng" => player.longest_rush,
      "1st" => player.first_downs,
      "1st%" => player.first_down_percentage,
      "20+" => player.twenty_plus_yards,
      "40+" => player.forty_plus_yards,
      "FUM" => player.total_fumbles
    }
  end

  def build_headers() do
    [
      "Player",
      "Team",
      "Pos",
      "Att/G",
      "Att",
      "Yds",
      "Avg",
      "Yds/G",
      "TD",
      "Lng",
      "1st",
      "1st%",
      "20+",
      "40+",
      "FUM"
    ]
  end
end