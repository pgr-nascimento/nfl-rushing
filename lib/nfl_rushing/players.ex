defmodule NflRushing.Players do
  alias NflRushing.Repo
  alias NflRushing.Players.{Export, Player}

  import Ecto.Query

  @typedoc """
    * name - used to filter the player name, accepts partial words (the fn will filter using LIKE %name%)
    * order_by - order by a specific field
    * direction - Ascending (asc) or Desceding (desc)
    * limit - How much players Ecto should returns
    * offset - Used to paginate the players
  """
  @type params :: %{
          name: String.t(),
          order_by: String.t(),
          direction: String.t(),
          limit: number(),
          offset: number()
        }

  defp base_query do
    from(p in Player)
  end

  @doc """
  This fn receives the params and count the total of players in the database, if a name is receibed in params map, the fn will filter
  and do the count after it.
  """
  @spec count_players(params()) :: integer()
  def count_players(params) do
    base_query()
    |> count_query
    |> filter_query(params)
    |> Repo.one()
  end

  @doc """
  This fn receives the params, apply the filter, order the query and paginate (apply the limit and offset) when the keys exists in params
  """
  @spec all(params()) :: list(Player.t())
  def all(params) do
    base_query()
    |> filter_query(params)
    |> order_query(params)
    |> paginate(params)
    |> Repo.all()
  end

  @doc """
  This fn receives the params, apply the filter, order the query and transform the %Player{} in a simple map
  """
  def export_csv(params) do
    base_query()
    |> filter_query(params)
    |> order_query(params)
    |> Repo.all()
    |> Enum.map(&Export.build_player/1)
  end

  defp count_query(query) do
    from(p in query, select: count(p.id))
  end

  defp filter_query(query, %{name: name}) do
    where(query, [player], ilike(player.name, ^"%#{name}%"))
  end

  defp filter_query(query, _params), do: query

  defp order_query(query, %{order_by: field, direction: direction}) do
    from p in query, order_by: {^direction, ^field}
  end

  defp order_query(query, _params), do: query

  defp paginate(query, %{limit: limit, offset: offset}) do
    from p in query, limit: ^limit, offset: ^offset
  end

  defp paginate(query, _params), do: query
end
