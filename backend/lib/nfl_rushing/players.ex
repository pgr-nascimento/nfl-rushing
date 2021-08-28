defmodule NflRushing.Players do
  alias NflRushing.Repo
  alias NflRushing.Players.Player

  import Ecto.Query

  defp base_query do
    from(p in Player)
  end

  @doc """
  It returns all players from database applying filters, orders, limit and offset if receives these attributes.
  """
  def all(params) do
    base_query()
    |> filter_query(params)
    |> order_query(params)
    |> paginate(params)
    |> Repo.all()
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
