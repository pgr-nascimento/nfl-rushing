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

  describe "GET /api/players?name=player_name" do
    test "when the params is empty, list all players", %{conn: conn} do
      insert(:player, %{name: "Joe Cavalera"})
      insert(:player, %{name: "Joe Doe"})
      insert(:player, %{name: "Sebastian Edgard"})

      response =
        conn
        |> get("/api/players?name=")
        |> json_response(:ok)

      assert [
               %{"name" => "Joe Cavalera"},
               %{"name" => "Joe Doe"},
               %{"name" => "Sebastian Edgard"}
             ] = response
    end

    test "list all players with the same name corresponding to the query string", %{conn: conn} do
      insert(:player, %{name: "Joe Cavalera"})
      insert(:player, %{name: "Joe Doe"})
      insert(:player, %{name: "Sebastian Edgard"})

      response =
        conn
        |> get("/api/players?name=joe")
        |> json_response(:ok)

      assert [%{"name" => "Joe Cavalera"}, %{"name" => "Joe Doe"}] = response
    end

    test "list all players with matches the partial name on the query string", %{conn: conn} do
      insert(:player, %{name: "Joe Cavalera"})
      insert(:player, %{name: "Joe Doe"})
      insert(:player, %{name: "Sebastian Edgard"})
      insert(:player, %{name: "Solomon Evoe"})
      insert(:player, %{name: "Alan Duncan"})

      response =
        conn
        |> get("/api/players?name=oe")
        |> json_response(:ok)

      assert [%{"name" => "Joe Cavalera"}, %{"name" => "Joe Doe"}, %{"name" => "Solomon Evoe"}] =
               response
    end
  end
end
