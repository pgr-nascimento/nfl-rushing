defmodule NflRushingWeb.PlayerView do
  use NflRushingWeb, :view

  def render("players.json", %{players: players}) do
    players
  end
end
