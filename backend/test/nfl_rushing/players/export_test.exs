defmodule NflRushing.Players.ExportTest do
  use ExUnit.Case, async: true

  alias NflRushing.Players.{Export, Player}

  import NflRushing.Factory

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
end
