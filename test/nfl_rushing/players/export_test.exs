defmodule NflRushing.Players.ExportTest do
  use ExUnit.Case, async: true

  alias NflRushing.Players.{Export, Player}

  describe "build_headers/0" do
    test "it should returns the collumns summarized" do
      headers = [
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

      assert ^headers = Export.build_headers()
    end
  end

  describe "build_player/1" do
    test "it should transforms the %Player{} struct in a simple Map" do
      player = %Player{
        attempts: 2,
        attempts_per_game_average: 2.0,
        average_yards_per_attempt: 3.0,
        first_downs: 1,
        first_down_percentage: 2.2,
        forty_plus_yards: 2,
        longest_rush: 7,
        longest_rush_touchdown: false,
        name: "Joe Banyard",
        position: "RB",
        team_acronym: "JAX",
        total_fumbles: 3,
        total_touchdowns: 4,
        total_yards: 3.0,
        twenty_plus_yards: 5,
        yards_per_game: 7.0
      }

      player2 = %Player{
        attempts: 2,
        attempts_per_game_average: 2.0,
        average_yards_per_attempt: 3.0,
        first_downs: 1,
        first_down_percentage: 2.2,
        forty_plus_yards: 2,
        longest_rush: 7,
        longest_rush_touchdown: true,
        name: "Lance Dunbar",
        position: "RB",
        team_acronym: "DAL",
        total_fumbles: 3,
        total_touchdowns: 4,
        total_yards: 3.0,
        twenty_plus_yards: 5,
        yards_per_game: 7.0
      }

      converted_player = %{
        "Player" => "Joe Banyard",
        "Team" => "JAX",
        "Pos" => "RB",
        "Att/G" => 2.0,
        "Att" => 2,
        "Yds" => 3.0,
        "Avg" => 3.0,
        "Yds/G" => 7.0,
        "TD" => 4,
        "Lng" => 7,
        "1st" => 1,
        "1st%" => 2.2,
        "20+" => 5,
        "40+" => 2,
        "FUM" => 3
      }

      converted_player2 = %{
        "Player" => "Lance Dunbar",
        "Team" => "DAL",
        "Pos" => "RB",
        "Att/G" => 2.0,
        "Att" => 2,
        "Yds" => 3.0,
        "Avg" => 3.0,
        "Yds/G" => 7.0,
        "TD" => 4,
        "Lng" => "7T",
        "1st" => 1,
        "1st%" => 2.2,
        "20+" => 5,
        "40+" => 2,
        "FUM" => 3
      }

      assert ^converted_player = Export.build_player(player)
      assert ^converted_player2 = Export.build_player(player2)
    end
  end
end
