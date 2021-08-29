defmodule NflRushingWeb.PlayerView do
  use NflRushingWeb, :view

  def headers do
    [
      "Player",
      "Team",
      "Pos",
      "Att/G",
      "Att",
      "Yds",
      "Avg",
      "Yds/G",
      "TD",
      "Lng",
      "1st",
      "1st%",
      "20+",
      "40+",
      "FUM"
    ]
  end
end
