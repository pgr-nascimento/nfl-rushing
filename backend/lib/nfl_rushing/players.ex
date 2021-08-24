defmodule NflRushing.Players do
  alias NflRushing.Repo

  @doc """
  It returns all players from database or return an empty list
  """
  def list_all() do
    Repo.all(NflRushing.Player)
  end
end
