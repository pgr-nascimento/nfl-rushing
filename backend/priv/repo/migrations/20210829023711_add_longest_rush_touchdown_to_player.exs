defmodule NflRushing.Repo.Migrations.AddLongestRushTouchdownToPlayer do
  use Ecto.Migration

  def change do
    alter table(:players) do
      add(:longest_rush_touchdown, :boolean)
    end
  end
end
