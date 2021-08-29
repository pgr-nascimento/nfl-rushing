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

  describe "previous_page/1" do
    test "It should reduces the offset total based on the limit" do
      params = %{limit: 10, offset: 40}

      assert %{limit: 10, offset: 30} = PlayerView.previous_page(params)
    end

    test "It should returns 0 if the offset would be less than 0" do
      params = %{limit: 10, offset: 5}

      assert %{limit: 10, offset: 0} = PlayerView.previous_page(params)
    end
  end
end
