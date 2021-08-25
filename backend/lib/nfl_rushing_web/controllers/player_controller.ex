defmodule NflRushingWeb.PlayerController do
  use NflRushingWeb, :controller

  alias NflRushing.Players

  def index(conn, params) do
    players =
      %{
        "name" => Map.get(params, "name", ""),
        "order_by" => Map.get(params, "order_by", ""),
        "direction" => Map.get(params, "direction", "asc")
      }
      |> Players.all()

    render(conn, "players.json", %{players: players})
  end
end
