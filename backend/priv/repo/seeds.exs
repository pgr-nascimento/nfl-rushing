# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     NflRushing.Repo.insert!(%NflRushing.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias NflRushing.Repo
alias NflRushing.Players.Player

defmodule PlayerSeed do
  def longest_rush_stats(longest_rush) when is_binary(longest_rush) do
    case String.split(longest_rush, "T") do
      [number] -> {number, false}
      [number, _] -> {number, true}
    end
  end

  def longest_rush_stats(longest_rush) when is_integer(longest_rush) do
    longest_rush_stats(Integer.to_string(longest_rush))
  end

  def convert_to_float(number) when is_float(number), do: number

  def convert_to_float(number) when is_integer(number) do
    convert_to_float(Integer.to_string(number))
  end

  def convert_to_float(number) when is_binary(number) do
    {floated_number, _} = Float.parse(number)
    floated_number
  end

  def adapt_player(player) do
    now = NaiveDateTime.utc_now()

    {longest_rush, scored?} = longest_rush_stats(player["Lng"])

    %{
      name: player["Player"],
      team_acronym: player["Team"],
      position: player["Pos"],
      attempts: player["Att"],
      attempts_per_game_average: convert_to_float(player["Att/G"]),
      total_yards: convert_to_float(player["Yds"]),
      average_yards_per_attempt: convert_to_float(player["Avg"]),
      yards_per_game: convert_to_float(player["Yds/G"]),
      total_touchdowns: player["TD"],
      longest_rush: String.to_integer(longest_rush),
      longest_rush_touchdown: scored?,
      first_downs: player["1st"],
      first_down_percentage: convert_to_float(player["1st%"]),
      twenty_plus_yards: player["20+"],
      forty_plus_yards: player["40+"],
      total_fumbles: player["FUM"],
      inserted_at: NaiveDateTime.truncate(now, :second),
      updated_at: NaiveDateTime.truncate(now, :second)
    }
  end
end

players =
  :code.priv_dir(:nfl_rushing)
  |> Path.join("rushing.json")
  |> File.read!()
  |> Jason.decode!()
  |> Enum.map(&PlayerSeed.adapt_player/1)

Repo.insert_all(Player, players)
