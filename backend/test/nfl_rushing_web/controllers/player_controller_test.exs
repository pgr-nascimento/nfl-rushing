defmodule NflRushingWeb.PlayerControllerTest do
  use NflRushingWeb.ConnCase, async: true

  import NflRushing.Factory

  describe "GET /api/players" do
    test "when there is not players, should return an empty list", %{conn: conn} do
      response =
        conn
        |> get("api/players")
        |> json_response(:ok)

      assert [] == response
    end

    test "list all players registered on database", %{conn: conn} do
      insert(:player, %{name: "Joe Cavalera"})
      insert(:player, %{name: "Joe Doe"})

      response =
        conn
        |> get("/api/players")
        |> json_response(:ok)

      assert [%{"name" => "Joe Cavalera"}, %{"name" => "Joe Doe"}] = response
    end
  end
end
