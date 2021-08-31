defmodule NflRushingWeb.PlayerController do
  use NflRushingWeb, :controller

  alias NflRushing.{Params, Players}

  def index(conn, params) do
    user_params = Params.parse(params)
    total = Players.count_players(user_params)
    players = Players.all(user_params)

    render(conn, "index.html", %{players: players, user_params: user_params, total_players: total})
  end
end
