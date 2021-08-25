defmodule NflRushing.PlayersTest do
  use NflRushing.DataCase, async: true

  import NflRushing.Factory

  alias NflRushing.{Player, Players}

  describe "all/1" do
    test "when there is no data, should return an empty list" do
      assert [] == Players.all(%{})
    end

    test "when there is data and no filters, should return all players" do
      insert_list(3, :player)

      result = Players.all(%{})

      assert 3 == Enum.count(result)
      assert [%Player{}, %Player{}, %Player{}] = result
    end
  end

  describe "filters" do
    test "when it receives an empty value, do not apply the filter" do
      player1 = insert(:player, %{name: "Joe Cavalera"})
      player2 = insert(:player, %{name: "Joe Doe"})
      player3 = insert(:player, %{name: "Sebastian Edgard"})

      result = Players.all(%{"name" => ""})

      assert [^player1, ^player2, ^player3] = result
    end

    test "when it receives a value, and that is a complete name, it should returns just the players that matches." do
      player1 = insert(:player, %{name: "Joe Cavalera"})
      player2 = insert(:player, %{name: "Joe Doe"})
      player3 = insert(:player, %{name: "Sebastian Edgard"})

      result =
        %{"name" => "Joe"}
        |> Players.all()

      assert [^player1, ^player2] = result
      refute Enum.find(result, fn p -> p.name == player3.name end)
    end

    test "when it receives a value, and that is a partial name, it should returns just the players that matches." do
      player1 = insert(:player, %{name: "Mark Joseph"})
      player2 = insert(:player, %{name: "Joselin Aligator"})
      player3 = insert(:player, %{name: "Alan Doe"})

      result =
        %{"name" => "Jose"}
        |> Players.all()

      assert [^player1, ^player2] = result
      refute Enum.find(result, fn p -> p.name == player3.name end)
    end

    test "when it receives a value, and it is typed with downcase, it should returns the players normally." do
      player1 = insert(:player, %{name: "Joe Doe"})
      player2 = insert(:player, %{name: "Joe Cavalera"})
      player3 = insert(:player, %{name: "Alan Doe"})

      result =
        %{"name" => "doe"}
        |> Players.all()

      assert [^player1, ^player3] = result
      refute Enum.find(result, fn p -> p.name == player2.name end)
    end
  end

  describe "orders" do
    test "when it receives a value, should order the players using the param" do
      player1 = insert(:player, %{name: "Joe Cavalera", total_yards: 200.0})
      player2 = insert(:player, %{name: "Joe Doe", total_yards: 202.0})
      player3 = insert(:player, %{name: "Sebastian Edgard", total_yards: 198.0})

      field = draw_ordered_field()

      expected = sort_players_by_field([player1, player2, player3], field)
      result = Players.all(%{"order_by" => field})

      assert ^expected = result
    end
  end

  def draw_ordered_field(), do: Enum.random(["total_yards", "longest_rush", "total_touchdowns"])

  def sort_players_by_field(players, field) do
    Enum.sort_by(players, &Map.get(&1, String.to_existing_atom(field)))
  end
end
