defmodule NflRushing.Params do
  @valid_directions ["asc", "desc"]
  @sortable_fields ["total_yards", "longest_rush", "total_touchdowns"]
  @default_limit 10
  @default_offset 0


  @typedoc """
    * name - used to filter the player name, accepts partial words (the fn will filter using LIKE %name%)
    * order_by - order by a specific field
    * direction - Ascending (asc) or Desceding (desc)
    * limit - How much players Ecto should returns
    * offset - Used to paginate the players

    %{"name" => "Joe",
      "order_by" => total_yards" | "longest_rush" | "total_touchdowns",
      "direction" => "asc" | "desc",
      "limit" => "10",
      "offset" => "0"}
  """
  @type wire_params :: %{String.t() => String.t(), String.t() => String.t(), String.t() => String.t(), String.t() => String.t(), String.t() => String.t()}
  @type params :: %{name: String.t(), order_by: String.t(), direction: String.t(), limit: number(), offset: number()}


  defp base_params do
    %{direction: :asc, order_by: :total_yards, limit: @default_limit, offset: @default_offset}
  end

  @doc """
  This fn transform the params from the request with key strings, change it to atoms
  and use the default values or the values received by query string.
  """

  @spec parse(wire_params()) :: params
  def parse(wire_params) do
    Enum.reduce(wire_params, base_params(), &compose_params/2)
  end

  defp compose_params({"name", name}, params) do
    Map.put(params, :name, name)
  end

  defp compose_params({"order_by", field}, params) when field in @sortable_fields do
    Map.put(params, :order_by, String.to_existing_atom(field))
  end

  defp compose_params({"direction", direction}, params) when direction in @valid_directions do
    Map.put(params, :direction, String.to_existing_atom(direction))
  end

  defp compose_params({"limit", limit}, params) when is_integer(limit) do
    Map.put(params, :limit, limit)
  end

  defp compose_params({"limit", wire_limit}, params) when is_binary(wire_limit) do
    case Integer.parse(wire_limit) do
      {limit, _} ->
        compose_params({"limit", limit}, params)

      :error ->
        params
    end
  end

  defp compose_params({"offset", offset}, params) when is_integer(offset) and offset > 0 do
    Map.put(params, :offset, offset)
  end

  defp compose_params({"offset", wire_offset}, params)
       when is_binary(wire_offset) and wire_offset > 0 do
    case Integer.parse(wire_offset) do
      {offset, _} ->
        compose_params({"offset", offset}, params)

      :error ->
        params
    end
  end

  defp compose_params(_wire_params, params), do: params
end
