defmodule NflRushing.PlayersTest do
  use NflRushing.DataCase, async: true

  import NflRushing.Factory

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
end
