defmodule NflRushingWeb.PlayerController do
  use NflRushingWeb, :controller

  alias NflRushing.{Params, Players}
  alias NflRushing.Players.Export

  def index(conn, params) do
    user_params = Params.parse(params)
    total = Players.count_players(user_params)
    players = Players.all(user_params)

    render(conn, "index.html", %{players: players, user_params: user_params, total_players: total})
  end

  def export(conn, params) do
    user_params = Params.parse(params)
    players = Players.export_csv(user_params)

    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header("content-disposition", "attachment; filename=\"players.csv\"")
    |> send_resp(200, csv_content(players))
  end

  defp csv_content(players) do
    players
    |> CSV.encode(headers: Export.build_headers())
    |> Enum.to_list()
    |> to_string
  end
end
