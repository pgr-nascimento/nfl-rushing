defmodule NflRushing.Players.Export do
  alias NflRushing.Players.Player

  @doc """
  This fn transform the %Player{} struct in a simple map to generate the CSV rows
  """
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
      "Lng" => build_longest_rush(player.longest_rush, player.longest_rush_touchdown),
      "1st" => player.first_downs,
      "1st%" => player.first_down_percentage,
      "20+" => player.twenty_plus_yards,
      "40+" => player.forty_plus_yards,
      "FUM" => player.total_fumbles
    }
  end

  @doc """
  This fn build the row headers of the CSV file
  """
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

  defp build_longest_rush(longest_rush, longest_rush_touchdown)
       when longest_rush_touchdown == true,
       do: "#{longest_rush}T"

  defp build_longest_rush(longest_rush, _longest_rush_touchdown), do: longest_rush
end
