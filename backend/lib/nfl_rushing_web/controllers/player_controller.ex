defmodule NflRushingWeb.PlayerController do
  use NflRushingWeb, :controller

  alias NflRushing.Players

  def index(conn, _params) do
    players = Players.list_all()

    render(conn, "players.json", %{players: players})
  end
end
