defmodule NflRushingWeb.PlayerController do
  use NflRushingWeb, :controller

  alias NflRushing.Players

  def index(conn, params) do
    players =
      params
      |> Players.all()

    render(conn, "players.json", %{players: players})
  end
end
