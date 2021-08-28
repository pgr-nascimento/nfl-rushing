defmodule NflRushing.Params do
  @valid_directions ["asc", "desc"]
  @sortable_fields ["total_yards", "longest_rush", "total_touchdowns"]
  @default_limit 10
  @default_offset 0

  defp base_params do
    %{direction: :asc, order_by: :total_yards, limit: @default_limit, offset: @default_offset}
  end

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

  defp compose_params({"offset", offset}, params) when is_integer(offset) and offset > 0 do
    Map.put(params, :offset, offset)
  end

  defp compose_params(_wire_params, params), do: params
end
