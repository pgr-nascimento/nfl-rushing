defmodule NflRushingWeb.PlayerControllerTest do
  use NflRushingWeb.ConnCase, async: true

  import NflRushing.Factory

  describe "GET /players.csv" do
    test "it should shows the players in csv format", %{conn: conn} do
      csv_response =
        conn
        |> get(Routes.player_path(conn, :export))

      assert response_content_type(csv_response, :csv)
    end
  end

  describe "GET /api/players" do
    test "when there is not players, should return an empty list", %{conn: conn} do
      document =
        conn
        |> get(Routes.player_path(conn, :index))
        |> html_response(:ok)
        |> Floki.parse_document!()

      assert "" == Floki.find(document, "tbody") |> Floki.text()
    end

    test "list all players registered on database", %{conn: conn} do
      insert(:player, %{name: "Joe Cavalera"})
      insert(:player, %{name: "Joe Doe"})

      [first_player_name, second_player_name] =
        conn
        |> get(Routes.player_path(conn, :index))
        |> html_response(:ok)
        |> Floki.parse_document!()
        |> Floki.find("tbody tr td[name=player]")
        |> Enum.map(&Floki.text/1)

      assert first_player_name =~ "Joe Cavalera"
      assert second_player_name =~ "Joe Doe"
    end

    test "when the player scored a touchdown on its longest_rush, shows a ball image", %{
      conn: conn
    } do
      insert(:player, %{name: "Joe Cavalera", longest_rush_touchdown: false})
      insert(:player, %{name: "Joe Doe", longest_rush_touchdown: true})

      [first_line, second_line] =
        conn
        |> get(Routes.player_path(conn, :index))
        |> html_response(:ok)
        |> Floki.parse_document!()
        |> Floki.find("tbody tr td[name=longest_rush]")

      first_player = Floki.raw_html(first_line)
      second_player = Floki.raw_html(second_line)

      refute first_player =~ "ball.svg"
      assert second_player =~ "ball.svg"
    end
  end

  describe "GET /api/players?name=player_name" do
    test "when the params is empty, list all players", %{conn: conn} do
      insert(:player, %{name: "Joe Cavalera"})
      insert(:player, %{name: "Joe Doe"})
      insert(:player, %{name: "Sebastian Edgard"})

      [first_player_name, second_player_name, third_player_name] =
        conn
        |> get(Routes.player_path(conn, :index))
        |> html_response(:ok)
        |> Floki.parse_document!()
        |> Floki.find("tbody tr td[name=player]")
        |> Enum.map(&Floki.text/1)

      assert first_player_name =~ "Joe Cavalera"
      assert second_player_name =~ "Joe Doe"
      assert third_player_name =~ "Sebastian Edgard"
    end

    test "list all players with the same name corresponding to the query string", %{conn: conn} do
      insert(:player, %{name: "Joe Cavalera"})
      insert(:player, %{name: "Joe Doe"})
      insert(:player, %{name: "Sebastian Edgard"})

      [first_player_name, second_player_name] =
        conn
        |> get(Routes.player_path(conn, :index), name: "joe")
        |> html_response(:ok)
        |> Floki.parse_document!()
        |> Floki.find("tbody tr td[name=player]")
        |> Enum.map(&Floki.text/1)

      assert first_player_name =~ "Joe Cavalera"
      assert second_player_name =~ "Joe Doe"
    end

    test "list all players with matches the partial name on the query string", %{conn: conn} do
      insert(:player, %{name: "Joe Cavalera"})
      insert(:player, %{name: "Joe Doe"})
      insert(:player, %{name: "Sebastian Edgard"})
      insert(:player, %{name: "Solomon Evoe"})
      insert(:player, %{name: "Alan Duncan"})

      [first_player_name, second_player_name, third_player_name] =
        conn
        |> get(Routes.player_path(conn, :index), name: "oe")
        |> html_response(:ok)
        |> Floki.parse_document!()
        |> Floki.find("tbody tr td[name=player]")
        |> Enum.map(&Floki.text/1)

      assert first_player_name =~ "Joe Cavalera"
      assert second_player_name =~ "Joe Doe"
      assert third_player_name =~ "Solomon Evoe"
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
      [first_player_name, second_player_name, third_player_name] =
        conn
        |> get(Routes.player_path(conn, :index), order_by: "total_yards", direction: "desc")
        |> html_response(:ok)
        |> Floki.parse_document!()
        |> Floki.find("tbody tr td[name=player]")
        |> Enum.map(&Floki.text/1)

      assert first_player_name =~ "Joe Doe"
      assert second_player_name =~ "Joe Cavalera"
      assert third_player_name =~ "Sebastian Edgard"
    end

    test "when receives a invalid ordered field, order the players default", %{conn: conn} do
      [first_player_name, second_player_name, third_player_name] =
        conn
        |> get(Routes.player_path(conn, :index), order_by: "name", direction: "desc")
        |> html_response(:ok)
        |> Floki.parse_document!()
        |> Floki.find("tbody tr td[name=player]")
        |> Enum.map(&Floki.text/1)

      assert first_player_name =~ "Joe Doe"
      assert second_player_name =~ "Joe Cavalera"
      assert third_player_name =~ "Sebastian Edgard"
    end

    test "when receives a invalid direction, order the players using the default direction",
         %{conn: conn} do
      [first_player_name, second_player_name, third_player_name] =
        conn
        |> get(Routes.player_path(conn, :index), order_by: "total_yards", direction: "updown")
        |> html_response(:ok)
        |> Floki.parse_document!()
        |> Floki.find("tbody tr td[name=player]")
        |> Enum.map(&Floki.text/1)

      assert first_player_name =~ "Joe Doe"
      assert second_player_name =~ "Joe Cavalera"
      assert third_player_name =~ "Sebastian Edgard"
    end
  end

  describe "GET /api/players?offset=offset&limit=limit" do
    test "with a limit, return a limited number of players", %{conn: conn} do
      insert(:player, %{name: "Joe Cavalera", total_yards: 200})
      insert(:player, %{name: "Joe Doe", total_yards: 210})
      insert(:player, %{name: "Sebastian Edgard", total_yards: 460})
      insert(:player, %{name: "Solomon Evoe", total_yards: 270})
      insert(:player, %{name: "Alan Duncan", total_yards: 300})

      [first_player_name, second_player_name] =
        conn
        |> get(Routes.player_path(conn, :index), limit: 2)
        |> html_response(:ok)
        |> Floki.parse_document!()
        |> Floki.find("tbody tr td[name=player]")
        |> Enum.map(&Floki.text/1)

      assert first_player_name =~ "Sebastian Edgard"
      assert second_player_name =~ "Alan Duncan"
    end

    test "with a limit and offset, return the playes in a paginated way", %{conn: conn} do
      insert(:player, %{name: "Joe Cavalera", total_yards: 200})
      insert(:player, %{name: "Joe Doe", total_yards: 210})
      insert(:player, %{name: "Sebastian Edgard", total_yards: 460})
      insert(:player, %{name: "Solomon Evoe", total_yards: 270})
      insert(:player, %{name: "Alan Duncan", total_yards: 300})

      [first_player_name] =
        conn
        |> get(Routes.player_path(conn, :index), limit: 2, offset: 4)
        |> html_response(:ok)
        |> Floki.parse_document!()
        |> Floki.find("tbody tr td[name=player]")
        |> Enum.map(&Floki.text/1)

      assert first_player_name =~ "Joe Cavalera"
    end
  end
end
