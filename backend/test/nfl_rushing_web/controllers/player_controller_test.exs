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

  describe "GET /api/players?order_by=player_stats" do
    setup %{conn: conn} do
      insert(:player, %{
        name: "Joe Cavalera",
        total_yards: 200.0,
        longest_rush: 10,
        total_touchdowns: 5
      })

      insert(:player, %{
        name: "Joe Doe",
        total_yards: 202.0,
        longest_rush: 12,
        total_touchdowns: 8
      })

      insert(:player, %{
        name: "Sebastian Edgard",
        total_yards: 198.0,
        longest_rush: 8,
        total_touchdowns: 3
      })

      {:ok, conn: conn}
    end

    test "when receives a valid ordered field and direction, order the players using they", %{
      conn: conn
    } do
      response =
        conn
        |> get("/api/players?order_by=total_yards&direction=desc")
        |> json_response(:ok)

      assert [
               %{"name" => "Joe Doe"},
               %{"name" => "Joe Cavalera"},
               %{"name" => "Sebastian Edgard"}
             ] = response
    end

    test "when receives a invalid ordered field, order the players default", %{conn: conn} do
      response =
        conn
        |> get("/api/players?order_by=name")
        |> json_response(:ok)

      assert [
               %{"name" => "Sebastian Edgard"},
               %{"name" => "Joe Cavalera"},
               %{"name" => "Joe Doe"}
             ] = response
    end

    test "when receives a invalid ordered , order the players default using the direction",
         %{conn: conn} do
      response =
        conn
        |> get("/api/players?order_by=name&direction=desc")
        |> json_response(:ok)

      assert [
               %{"name" => "Joe Doe"},
               %{"name" => "Joe Cavalera"},
               %{"name" => "Sebastian Edgard"}
             ] = response
    end
  end
end
