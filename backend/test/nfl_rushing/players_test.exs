defmodule NflRushing.PlayersTest do
  use NflRushing.DataCase, async: true

  import NflRushing.Factory

  alias NflRushing.Players
  alias NflRushing.Players.Player

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
      player2 = insert(:player, %{name: "Joe Cavalera"})
      player3 = insert(:player, %{name: "Alan Doe"})
      result = Players.all(%{name: ""})

      assert [^player1, ^player2, ^player3] = result
    end

    test "when it receives a value, and that is a complete name, it should returns just the players that matches." do
      player1 = insert(:player, %{name: "Joe Cavalera"})
      player2 = insert(:player, %{name: "Joe Doe"})
      player3 = insert(:player, %{name: "Sebastian Edgard"})

      result = Players.all(%{name: "Joe"})

      assert [^player1, ^player2] = result
      refute Enum.find(result, fn p -> p.name == player3.name end)
    end

    test "when it receives a value, and that is a partial name, it should returns just the players that matches." do
      player1 = insert(:player, %{name: "Mark Joseph"})
      player2 = insert(:player, %{name: "Joselin Aligator"})
      player3 = insert(:player, %{name: "Alan Doe"})

      result = Players.all(%{name: "Jose"})

      assert [^player1, ^player2] = result
      refute Enum.find(result, fn p -> p.name == player3.name end)
    end

    test "when it receives a value, and it is typed with downcase, it should returns the players normally." do
      player1 = insert(:player, %{name: "Joe Doe"})
      player2 = insert(:player, %{name: "Joe Cavalera"})
      player3 = insert(:player, %{name: "Alan Doe"})

      result = Players.all(%{name: "doe"})

      assert [^player1, ^player3] = result
      refute Enum.find(result, fn p -> p.name == player2.name end)
    end
  end

  describe "ordering" do
    setup do
      player1 =
        insert(:player, %{
          name: "Joe Cavalera",
          total_yards: 200.0,
          longest_rush: 10,
          total_touchdowns: 5
        })

      player2 =
        insert(:player, %{
          name: "Alan Doe",
          total_yards: 202.0,
          longest_rush: 12,
          total_touchdowns: 8
        })

      player3 =
        insert(:player, %{
          name: "Sebastian Edgard",
          total_yards: 198.0,
          longest_rush: 8,
          total_touchdowns: 3
        })

      {:ok, %{players: [player1, player2, player3]}}
    end

    test "when it receives an empty value, should ordering by default (id)", %{
      players: [player1, player2, player3]
    } do
      result = Players.all(%{order_by: ""})

      assert [^player1, ^player2, ^player3] = result
    end

    test "order players by total_yards ascending", %{
      players: [player1, player2, player3]
    } do
      result = Players.all(%{order_by: :total_yards, direction: :asc})

      assert [^player3, ^player1, ^player2] = result
    end

    test "order players by total_yards descending", %{
      players: [player1, player2, player3]
    } do
      result = Players.all(%{order_by: :total_yards, direction: :desc})

      assert [^player2, ^player1, ^player3] = result
    end

    test "order players by longest_rush ascending", %{
      players: [player1, player2, player3]
    } do
      result = Players.all(%{order_by: :longest_rush, direction: :asc})

      assert [^player3, ^player1, ^player2] = result
    end

    test "order players by longest_rush descending", %{
      players: [player1, player2, player3]
    } do
      result = Players.all(%{order_by: :longest_rush, direction: :desc})

      assert [^player2, ^player1, ^player3] = result
    end

    test "order players by total_touchdowns ascending", %{
      players: [player1, player2, player3]
    } do
      result = Players.all(%{order_by: :total_touchdowns, direction: :asc})

      assert [^player3, ^player1, ^player2] = result
    end

    test "order players by total_touchdowns descending", %{
      players: [player1, player2, player3]
    } do
      result = Players.all(%{order_by: :total_touchdowns, direction: :desc})

      assert [^player2, ^player1, ^player3] = result
    end
  end

  describe "offset & limit" do
    test "when it does not receive a limit, should returns all the players" do
      insert_list(11, :player)

      result = Players.all(%{})

      assert Enum.all?(result, fn player -> %Player{} = player end)
      assert Enum.count(result) == 11
    end

    test "when it receives a limit, should returns only the limit number of players" do
      insert_list(20, :player)

      result = Players.all(%{offset: 0, limit: 12})

      assert Enum.count(result) == 12
    end

    test "when it receives an offset and limit, should return the values of the current offset page" do
      insert_list(20, :player)
      player1 = insert(:player, %{name: "Joe Doe"})
      player2 = insert(:player, %{name: "Joe Cavalera"})
      player3 = insert(:player, %{name: "Alan Doe"})

      result = Players.all(%{limit: 10, offset: 20})

      assert Enum.count(result) == 3
      assert [^player1, ^player2, ^player3] = result
    end
  end
end
