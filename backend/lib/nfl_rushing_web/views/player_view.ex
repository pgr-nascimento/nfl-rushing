defmodule NflRushingWeb.PlayerView do
  use NflRushingWeb, :view

  @type params :: %{name: String.t(), order_by: String.t(), direction: String.t(), limit: number(), offset: number()}

  @doc """
  This fn returns a list of the columns to show the players to the users, here we abbreviate the columns to show.
  """
  @spec headers :: list(String.t())
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

  @doc """
    This fn handles with the offset to send to the database which page it should show to the user
  """
  @spec previous_page(params()) :: params()
  def previous_page(%{offset: offset, limit: limit} = params) do
    new_offset = offset - limit

    if new_offset >= 0 do
      %{params | offset: offset - limit}
    else
      %{params | offset: 0}
    end
  end

  @doc """
    This fn handles with the offset to send to the database which page it should show to the user
  """
  @spec next_page(params, number()) :: params()
  def next_page(%{offset: offset, limit: limit} = params, total) do
    new_offset = offset + limit

    if new_offset <= total do
      %{params | offset: new_offset}
    else
      %{params | offset: total - limit}
    end
  end


  @doc """
    This fn build the link to send the user to the previous or the next page
  """
  @spec get_path(atom(), params(), number(), Plug.Conn.t()) :: String.t()
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
