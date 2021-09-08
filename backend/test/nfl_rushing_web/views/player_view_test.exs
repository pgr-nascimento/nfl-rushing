defmodule NflRushingWeb.PlayerViewTest do
  use NflRushingWeb.ConnCase, async: true

  alias NflRushingWeb.PlayerView
  alias Phoenix.HTML

  import NflRushing.Factory

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

  describe "show_pagination_link?/3" do
    test "With :previous_page, should returns false when the offset is zero" do
      params = %{offset: 0}

      total = 10

      refute PlayerView.show_pagination_link?(:previous_page, params, total)
    end

    test "With :previous_page, should returns true" do
      params = %{offset: 30, limit: 10}

      total = 40

      assert PlayerView.show_pagination_link?(:previous_page, params, total)
    end

    test "With :next_page, should returns false when the offset greather or equal the limit" do
      params = %{limit: 10, offset: 57}
      total = 57

      refute PlayerView.show_pagination_link?(:next_page, params, total)
    end

    test "With :next_page, should returns true when the offset is less than the limit" do
      params = %{offset: 20, limit: 10}

      total = 40

      assert PlayerView.show_pagination_link?(:next_page, params, total)
    end
  end

  describe "build_order_link/3" do
    test "when the header is not a orderable link, it should returns the header name" do
      header = "Player"

      assert ^header = PlayerView.build_order_link(header, %{}, NflRushingWeb.Endpoint)
    end

    test "when the header is a orderable link, it should returns a link with the header" do
      {order_by_column, header} =
        Enum.random([{"total_yards", "Yds"}, {"longest_rush", "Lng"}, {"total_touchdowns", "TD"}])

      query_string = "order_by=#{order_by_column}"

      result =
        Phoenix.HTML.safe_to_string(
          PlayerView.build_order_link(header, %{}, NflRushingWeb.Endpoint)
        )

      assert result =~ query_string
    end

    test "when the header is a orderable link and has a filter, should keep the filter in the query string" do
      header = "TD"

      query_string_name = "name=joe"
      query_string_order = "order_by=total_touchdowns"

      result =
        header
        |> PlayerView.build_order_link(%{name: "joe"}, NflRushingWeb.Endpoint)
        |> HTML.safe_to_string()

      assert result =~ query_string_name
      assert result =~ query_string_order
    end

    test "when the header is a orderable link and has a direction, should toggle the direction in the query string" do
      header = "Lng"

      query_string_direction = "direction=desc"

      result =
        header
        |> PlayerView.build_order_link(%{direction: :asc}, NflRushingWeb.Endpoint)
        |> HTML.safe_to_string()

      assert result =~ query_string_direction
    end
  end

  describe "scored_touchdown?/1" do
    test "when longest_rush_touchdown is false, it should returns false" do
      player = insert(:player, %{longest_rush_touchdown: false})

      assert false == PlayerView.scored_touchdown?(player)
    end

    test "when longest_rush_touchdown is true, it should returns true" do
      player = insert(:player, %{longest_rush_touchdown: true})

      assert true == PlayerView.scored_touchdown?(player)
    end
  end
end
