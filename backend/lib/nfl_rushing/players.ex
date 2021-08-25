defmodule NflRushing.Players do
  alias NflRushing.{Player, Repo}
  import Ecto.Query

  defp base_query do
    from(p in Player)
  end

  @doc """
  It returns all players from database or return an empty list
  """
  def all(_params) do
    base_query()
    |> Repo.all()
  end
end
