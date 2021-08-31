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

  def previous_page(%{offset: offset, limit: limit} = params) do
    new_offset = offset - limit

    if new_offset >= 0 do
      %{params | offset: offset - limit}
    else
      %{params | offset: 0}
    end
  end

  def next_page(%{offset: offset, limit: limit} = params, total) do
    new_offset = offset + limit

    if new_offset <= total do
      %{params | offset: new_offset}
    else
      %{params | offset: total - limit}
    end
  end

  def get_path(:previous_page, %{offset: 0}, _total, _conn), do: "#"

  def get_path(:previous_page, params, _total, conn),
    do: Routes.player_path(conn, :index, previous_page(params))

  def get_path(:next_page, %{offset: offset, limit: limit} = params, total, conn) do
    new_offset = offset + limit

    if new_offset <= total do
      Routes.player_path(conn, :index, next_page(params, total))
    else
      "#"
    end
  end
end
