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

  def show_pagination_link?(:previous_page, %{offset: 0}, _total_players), do: false
  def show_pagination_link?(:previous_page, _params, _total_players), do: true

  def show_pagination_link?(:next_page, %{offset: offset, limit: limit}, total_players) do
    new_offset = offset + limit

    if new_offset <= total_players, do: true, else: false
  end
end
