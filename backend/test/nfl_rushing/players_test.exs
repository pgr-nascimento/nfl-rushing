defmodule NflRushing.PlayersTest do
  use NflRushing.DataCase, async: true

  import NflRushing.Factory
  import Ecto.Query, only: [from: 2]

  alias NflRushing.{Player, Players}

  describe "all/1" do
    test "when there is no data, should return an empty list" do
      assert [] == Players.all()
    end

    test "when there is data, should return all players" do
      insert_list(3, :player)

      result = Players.all()

      assert 3 == Enum.count(result)
      assert [%Player{}, %Player{}, %Player{}] = result
    end
  end
end
