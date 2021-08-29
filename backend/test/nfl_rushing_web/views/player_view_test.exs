defmodule NflRushingWeb.ErrorViewTest do
  use NflRushingWeb.ConnCase, async: true

  alias NflRushingWeb.PlayerView

  describe "headers/0" do
    test "It should returns the content of the headers from player's table" do
      assert [
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
             ] = PlayerView.headers()
    end
  end
end
