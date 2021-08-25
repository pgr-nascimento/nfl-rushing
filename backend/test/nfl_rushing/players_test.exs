defmodule NflRushing.PlayersTest do
  use NflRushing.DataCase, async: true

  import NflRushing.Factory
  import Ecto.Query, only: [from: 2]

  alias NflRushing.{Player, Players}

  describe "list_all/0" do
    test "when there is no data, should return an empty list" do
      assert [] == Players.list_all()
    end

    test "when there is data, should return all players" do
      insert_list(3, :player)

      result = Players.list_all()

      assert 3 == Enum.count(result)
      assert [%Player{}, %Player{}, %Player{}] = result
    end
  end

  describe "list_all/1" do
    test "when receives a queryable with values, should return all the values" do
      insert_list(3, :player, %{name: "Joseph Due"})

      player = insert(:player, %{name: "John Doe"})
      query = from p in Player, where: p.name == "John Doe"

      assert [player] = Player.list_all(query)
    end
  end
end
