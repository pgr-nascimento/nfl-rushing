defmodule NflRushingWeb.PlayerView do
  use NflRushingWeb, :view

  alias NflRushing.Players.Player

  import Phoenix.HTML.Link, only: [link: 2]

  @ordered_headers ["Yds", "Lng", "TD"]

  @sortable_columns %{"Yds" => "total_yards", "Lng" => "longest_rush", "TD" => "total_touchdowns"}

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

  def build_order_link(header, params, conn)
      when header in @ordered_headers do
    order_by = Map.get(@sortable_columns, header)

    link(header, to: order_route(params, order_by, conn), method: :get)
  end

  def build_order_link(header, _params, _conn), do: header

  defp toggle_direction(:asc), do: "desc"
  defp toggle_direction(:desc), do: "asc"
  defp toggle_direction(_direction), do: "desc"

  defp order_route(params, new_order_by, conn) do
    new_params =
      %{
        direction: toggle_direction(Map.get(params, :direction)),
        order_by: new_order_by,
        name: Map.get(params, :name)
      }
      |> Enum.reject(fn {_key, value} -> value == nil end)
      |> Enum.into(%{})

    Routes.player_path(conn, :index, new_params)
  end

  @doc """
  This fn check the longest_rush_touchdown column and return its value. Just to give a
  better idiomatic name to the column.
  """
  def scored_touchdown?(%Player{longest_rush_touchdown: longest_rush_touchdown}) do
    longest_rush_touchdown
  end
end
