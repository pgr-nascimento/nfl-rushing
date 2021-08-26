defmodule NflRushingWeb.PlayerController do
  use NflRushingWeb, :controller

  alias NflRushing.{Params, Players}

  def index(conn, params) do
    players =
      params
      |> Params.parse()
      |> IO.inspect()
      |> Players.all()

    render(conn, "players.json", %{players: players})
  end
end
