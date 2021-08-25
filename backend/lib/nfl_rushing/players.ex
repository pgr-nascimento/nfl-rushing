defmodule NflRushing.Players do
  alias NflRushing.Repo

  @doc """
  It returns all players from database or return an empty list
  """
  def list_all(queryable \\ NflRushing.Player) do
    Repo.all(queryable)
  end
end
