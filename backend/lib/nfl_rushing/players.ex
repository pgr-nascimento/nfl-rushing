defmodule NflRushing.Players do
  alias NflRushing.{Player, Repo}
  import Ecto.Query

  defp base_query do
    from(p in Player)
  end

  @doc """
  It returns all players from database or return an empty list
  """
  def all(params) do
    base_query()
    |> filter_query(params)
    |> Repo.all()
  end

  defp filter_query(query, %{"name" => name}) do
    where(query, [player], ilike(player.name, ^"%#{name}%"))
  end

  defp filter_query(query, _params), do: query
end
