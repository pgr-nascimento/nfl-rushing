defmodule NflRushingWeb.PlayerViewTest do
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

  describe "next_page/2" do
    test "It should increases the offset total based on the limit" do
      params = %{limit: 10, offset: 30}
      total = 50

      assert %{limit: 10, offset: 40} = PlayerView.next_page(params, total)
    end

    test "It should returns total minus the limit, if the offset would be equal or greather than total" do
      params = %{limit: 10, offset: 57}
      total = 57

      assert %{limit: 10, offset: 47} = PlayerView.next_page(params, total)
    end
  end

  describe "get_path/4" do
    test "With :previous_page, should not change the URL when the offset is zero" do
      params = %{offset: 0}

      total = 10

      assert "#" == PlayerView.get_path(:previous_page, params, total, NflRushingWeb.ConnCase)
    end

    test "With :previous_page, should reduce the offset when the offset is not zero" do
      params = %{offset: 30, limit: 10}

      total = 40

      assert "/players?offset=20&limit=10" ==
               PlayerView.get_path(:previous_page, params, total, NflRushingWeb.Endpoint)
    end
  end
end
